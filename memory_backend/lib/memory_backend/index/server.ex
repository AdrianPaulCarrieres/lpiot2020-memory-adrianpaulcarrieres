defmodule MemoryBackend.Index.Server do
  @moduledoc """
  GenServer callbacks
  """
  use GenServer
  require Logger
  alias MemoryBackend.Index.Impl
  alias MemoryBackend.GameStore

  @impl true
  @doc """
  Initial state of our registry server.
  """
  def init([]) do
    games = %{}
    refs = %{}
    {:ok, {games, refs}}
  end

  @impl true
  def handle_call({:create_game, id, deck = %MemoryBackend.Model.Deck{}, player}, _from, state) do
    {games, refs} = state

    if Map.has_key?(games, id) do
      {:reply, {:error, "ID already in use."}, state}
    else
      {:ok, game_store} = MemoryBackend.GameStore.start_link([])
      game = Impl.create_game(id, deck, player)
      GameStore.set(game_store, game)

      ref = Process.monitor(game_store)
      refs = Map.put(refs, ref, id)
      games = Map.put(games, id, game_store)

      {:reply, {:ok, game}, {games, refs}}
    end
  end

  @impl true
  def handle_call({:find_game, id}, _from, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      {:reply, {:ok, GameStore.get(Map.get(games, id))}, state}
    else
      {:reply, {:error, :no_game}, state}
    end
  end

  @impl true
  def handle_call({:join_game, id, player}, _from, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      game_store = Map.get(games, id)
      game = GameStore.get(game_store)

      case Impl.join_game(game, player) do
        {:ok, game} ->
          GameStore.set(game_store, game)
          {:reply, {:ok, game}, state}

        {:error, _} ->
          {:reply, {:reconnect, game}, state}
      end
    else
      {:reply, {:error, :no_game}, state}
    end
  end

  @impl true
  def handle_call({:start_game, id}, _from, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      game_store = Map.get(games, id)

      game =
        GameStore.get(game_store)
        |> Impl.start_game()

      GameStore.set(game_store, game)

      Logger.info("Arming a new timer for game: #{inspect(id)}")
      Process.send_after(self(), {:afk_player, {id, 0}}, 30000)

      {:reply, {:ok, game}, state}
    else
      {:reply, {:error, :no_game}, state}
    end
  end

  @impl true
  def handle_call({:play_turn, id, active_player, card_index, turn}, _from, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      game_store = Map.get(games, id)
      game = GameStore.get(game_store)

      case Impl.play_turn(game, active_player, card_index, turn) do
        {:ok, {:ongoing, game}} ->
          GameStore.set(game_store, game)
          {:reply, {:ok, {:ongoing, game}}, state}

        {:ok, {:won, game}} ->
          GameStore.set(game_store, game)

          {actual_score, is_better_than_any_high_score} =
            Impl.end_game(game)
            |> Impl.calculate_best_scores()

          # Stop the game after a few minutes
          Process.send_after(self(), {:stop_game, id}, 60000)
          {:reply, {:ok, {:won, actual_score, is_better_than_any_high_score}}, state}

        {:error, msg} ->
          {:reply, {:error, msg}, state}
      end
    else
      {:reply, {:error, :no_game}, state}
    end
  end

  @impl true
  def handle_info({:afk_player, {id, old_turn}}, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      game_store = Map.get(games, id)
      game = GameStore.get(game_store)
      new_turn = game.turn_count

      game =
        if old_turn == new_turn do
          Impl.skip_turn(game)
        else
          game
        end

      # Send itself a message to stop the inactive game if all players are AFK for 2 turns
      if(game.consecutive_afk_players == length(game.players) * 2) do
        send(self(), {:stop_game, id})
      else
        GameStore.set(game_store, game)

        # put the timer again
        Process.send_after(self(), {:afk_player, {id, game.turn_count}}, 30000)
        Logger.info("Rearming timer for game: #{inspect(id)}")
      end

      {:noreply, state}
    else
      {:reply, {:error, :no_game}, state}
    end
  end

  @impl true
  def handle_info({:stop_game, id}, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      Map.get(games, id)
      |> Agent.stop()

      MemoryBackendWeb.Endpoint.broadcast!("general:" <> id, "disconnect", %{
        msg: "Quit the game"
      })

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  @doc """
  Processes crash and normal termination of GameStores
  """
  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {games, refs}) do
    {game_store, refs} = Map.pop(refs, ref)
    games = Map.delete(games, game_store)
    {:noreply, {games, refs}}
  end

  @doc """
  Discards unknow messages.
  """
  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
