defmodule MemoryBackendWeb.CardController do
  use MemoryBackendWeb, :controller

  alias MemoryBackend.Model
  alias MemoryBackend.Model.Card

  action_fallback MemoryBackendWeb.FallbackController

  def index(conn, %{"deck_id" => deck_id}) do
    deck = Model.get_deck!(deck_id)
    render(conn, "index.json", cards: deck.cards)
  end

  def create(conn, %{"deck_id" => deck_id, "card" => card_params}) do
    deck = Model.get_deck!(deck_id)

    with {:ok, %Card{} = card} <- Model.create_card(deck, card_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.deck_card_path(conn, :show, deck_id, card))
      |> render("show.json", card: card)
    end
  end

  def show(conn, %{"id" => id}) do
    card = Model.get_card!(id)
    render(conn, "show.json", card: card)
  end

  def update(conn, %{"id" => id, "card" => card_params}) do
    card = Model.get_card!(id)

    with {:ok, %Card{} = card} <- Model.update_card(card, card_params) do
      render(conn, "show.json", card: card)
    end
  end

  def delete(conn, %{"id" => id}) do
    card = Model.get_card!(id)

    with {:ok, %Card{}} <- Model.delete_card(card) do
      send_resp(conn, :no_content, "")
    end
  end
end
