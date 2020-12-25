defmodule MemoryBackend.Index.Server do
  @moduledoc """
  GenServer callbacks
  """
  use GenServer
  require Logger
  alias MemoryBackend.Index.Impl
  alias MemoryBackend.GameStore
  alias MemoryBackend.Game

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
    {games, _} = state

    if Map.has_key?(games, id) do
      {:reply, "ID already in use.", games}
    else
      {:ok, game_agent} = MemoryBackend.GameStore.start_link([])
      game = Impl.create_game(id, deck, player)
      GameStore.set(game_agent, game)
      {:reply, game, Map.put(games, id, game_agent)}
    end
  end

  @impl true
  def handle_call({:find_game, id}, _from, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      {:reply, GameStore.get(Map.get(games, id)), games}
    else
      {:reply, "No game registered with this id", games}
    end
  end

  @impl true
  def handle_call({:join_game, id, player}, _from, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      game_store = Map.get(games, id)

      result =
        GameStore.get(game_store)
        |> Game.join(player)

      case result do
        {:ok, game} ->
          GameStore.set(game_store, game)
          {:reply, {:ok, game}, games}

        {:error, msg} ->
          {:reply, {:error, msg}, games}
      end
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
      Process.send_after(self(), {:afk_player, {id, 0}}, 30000)
      Logger.info("Arming a new timer for game: #{inspect(id)}")

      {:reply, game, games}
    else
      {:reply, "No game registered with this id", games}
    end
  end

  @impl true
  def handle_call({:play_turn, id, active_player, card_index, turn}, _from, state) do
    {games, _} = state

    if Map.has_key?(games, id) do
      game_store = Map.get(games, id)
      game = GameStore.get(game_store)

      case Impl.play_turn(game, active_player, card_index, turn) do
        {:ok, {:ongoin, game}} ->
          GameStore.set(game_store, game)
          {:reply, {:ok, {:ongoin, game}}, games}

        {:ok, {:won, game}} ->
          GameStore.set(game_store, game)
          score = Impl.end_game(game)
          {:reply, {:ok, {:won, score}}, games}

        {:error, msg} ->
          {:reply, {:error, msg}, games}
      end
    else
      {:reply, {:error, "No game registered with this id"}, games}
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

      GameStore.set(game_store, game)

      # put the timer again
      Process.send_after(self(), {:afk_player, {id, game.turn_count}}, 30000)
      Logger.info("Rearming timer for game: #{inspect(id)}")
      {:noreply, games}
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
