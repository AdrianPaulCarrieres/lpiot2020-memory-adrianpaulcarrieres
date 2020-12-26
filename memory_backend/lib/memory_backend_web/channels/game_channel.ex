defmodule MemoryBackendWeb.GameChannel do
  use MemoryBackendWeb, :channel

  def join("game:" <> game_id, _params, socket) do
    {:ok, assign(socket, :game_id, game_id)}
  end
end
