defmodule MemoryBackendWeb.GameChannel do
  use MemoryBackendWeb, :channel
  alias MemoryBackend.Index

  def join("game:" <> game_id, _params, socket) do
    player = socket.assigns.player

    case Index.join_game(game_id, player) do
      {:ok, game} ->
        broadcast!(socket, "new_player", %{game: game, player: socket.assigns.player})
        {:ok, socket}

      {:reconnect, game} ->
        socket = assign(socket, :game_id, game_id)
        {:ok, %{game: game}, socket}

      {:error, :no_game} ->
        {:error, %{reason: "Game doesn't exists"}}
    end
  end

  def handle_in("start_game", _payload, socket) do
    "game:" <> game_id = socket.topic

    case Index.start_game(game_id) do
      {:ok, game} ->
        broadcast!(socket, "start_game", %{game: game})
        {:noreply, socket}

      {:error, msg} ->
        {:reply, {:error, msg}, socket}
    end
  end

  def handle_in("find_game", _payload, socket) do
    "game:" <> game_id = socket.topic

    case Index.find_game(game_id) do
      {:ok, game} -> {:reply, {:ok, game}, socket}
      error_tuple -> {:reply, error_tuple, socket}
    end
  end

  def handle_in("flip_card", {card_index, turn}, socket) do
    "game:" <> game_id = socket.topic
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
