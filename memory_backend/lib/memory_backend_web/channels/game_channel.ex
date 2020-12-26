defmodule MemoryBackendWeb.GameChannel do
  use MemoryBackendWeb, :channel
  alias MemoryBackend.Index

  def join("game:" <> game_id, _params, socket) do
    with {:ok, _} <- Index.find_game(game_id),
         {:ok, game} <- Index.join_game(game_id, socket.assigns.player) do
      socket = assign(socket, :game_id, game_id)
      broadcast!(socket, "new_player", %{game: game, player: socket.assigns.player})
      {:ok, socket}
    else
      _ ->
        {:error, %{reason: "Game doesn't exists"}}
    end
  end

  def handle_in("start_game", _payload, socket) do
    game_id = socket.assigns.game_id

    case Index.start_game(game_id) do
      {:ok, game} ->
        broadcast!(socket, "start_game", %{game: game})
        {:noreply, socket}

      {:error, msg} ->
        {:reply, {:error, msg}, socket}
    end
  end

  def handle_in("find_game", _payload, socket) do
    game_id = socket.assigns.game_id

    case Index.find_game(game_id) do
      {:ok, game} -> {:reply, {:ok, game}, socket}
      error_tuple -> {:reply, error_tuple, socket}
    end
  end

  def handle_in("flip_card", {card_index, turn}, socket) do
    game_id = socket.assigns.game_id
    active_player = socket.assigns.player

    case Index.flip_card(game_id, active_player, card_index, turn) do
      {:ok, {:ongoing, game}} ->
        broadcast!(socket, "turn_played", %{game: game})
        {:no_reply, socket}

      {:ok, {:won, score}} ->
        broadcast!(socket, "game_won", %{score: score})
        {:no_reply, socket}

      {:error, msg} ->
        {:reply, {:error, msg}, socket}
    end
  end
end
