defmodule MemoryBackendWeb.DeckView do
  use MemoryBackendWeb, :view
  alias MemoryBackendWeb.{DeckView, CardView}

  def render("index.json", %{decks: decks}) do
    %{data: render_many(decks, DeckView, "deck.json")}
  end

  def render("show.json", %{deck: deck}) do
    %{data: render_one(deck, DeckView, "deck_with_cards.json")}
  end

  def render("deck.json", %{deck: deck}) do
    %{id: deck.id, theme: deck.theme, card_back: Base.encode64(deck.card_back)}
  end

  def render("deck_with_cards.json", %{deck: deck}) do
    %{
      card_back: Base.encode64(deck.card_back),
      theme: deck.theme,
      cards: render_many(deck.cards, CardView, "card.json")
    }
  end
end
