defmodule MemoryBackendWeb.CardController do
  use MemoryBackendWeb, :controller

  alias MemoryBackend.Model
  alias MemoryBackend.Model.Card

  action_fallback MemoryBackendWeb.FallbackController

  def index(conn, _params) do
    cards = Model.list_cards()
    render(conn, "index.json", cards: cards)
  end

  def create(conn, %{"card" => card_params}) do
    with {:ok, %Card{} = card} <- Model.create_card(card_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.card_path(conn, :show, card))
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
