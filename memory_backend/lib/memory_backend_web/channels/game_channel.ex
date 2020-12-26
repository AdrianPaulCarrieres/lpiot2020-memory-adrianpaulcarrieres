defmodule MemoryBackendWeb.GameChannel do
  use MemoryBackendWeb, :channel
  alias MemoryBackend.Index

  def join("game:" <> game_id, _params, socket) do
    with {:ok, _} <- Index.find_game(game_id),
         {:ok, game} <- Index.join_game(game_id, socket.assigns.player) do
      socket = assign(socket, :game_id, game_id)
      broadcast!(socket, "new_player", %{game: game, player: socket})
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
end
