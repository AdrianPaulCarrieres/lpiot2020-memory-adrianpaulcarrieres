defmodule MemoryBackendWeb.ScoreChannel do
  use MemoryBackendWeb, :channel

  def join("score:" <> theme, _params, socket) do
    {:ok, assign(socket, :theme, theme)}
  end
end
