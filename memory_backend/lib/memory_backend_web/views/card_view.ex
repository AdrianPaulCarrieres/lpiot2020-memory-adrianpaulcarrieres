defmodule MemoryBackendWeb.CardView do
  use MemoryBackendWeb, :view
  alias MemoryBackendWeb.CardView

  def render("index.json", %{cards: cards}) do
    render_many(cards, CardView, "card.json")
  end

  def render("show.json", %{card: card}) do
    render_one(card, CardView, "card.json")
  end

  def render("card.json", %{card: card}) do
    %{id: card.id, image: Base.encode64(card.image)}
  end
end
