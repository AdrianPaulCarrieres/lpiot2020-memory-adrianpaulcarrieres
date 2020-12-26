defmodule MemoryBackendWeb.DeckView do
  use MemoryBackendWeb, :view
  alias MemoryBackendWeb.DeckView

  def render("index.json", %{decks: decks}) do
    %{data: render_many(decks, DeckView, "deck.json")}
  end

  def render("show.json", %{deck: deck}) do
    %{data: render_one(deck, DeckView, "deck.json")}
  end

  def render("deck.json", %{deck: deck}) do
    %{id: deck.id,
      theme: deck.theme,
      card_back: deck.card_back}
  end
end
