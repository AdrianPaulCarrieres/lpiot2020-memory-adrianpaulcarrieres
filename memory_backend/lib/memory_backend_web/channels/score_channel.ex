defmodule MemoryBackendWeb.ScoreChannel do
  use MemoryBackendWeb, :channel

  def join("score:" <> deck_id, _params, socket) do
    scores =
      MemoryBackend.Model.Deck.get_associated_high_scores(%MemoryBackend.Model.Deck{id: deck_id})

    {:ok, assign(socket, :score, scores)}
  end
end
