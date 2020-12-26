defmodule MemoryBackendWeb.DeckController do
  use MemoryBackendWeb, :controller

  alias MemoryBackend.Model
  alias MemoryBackend.Model.Deck

  action_fallback MemoryBackendWeb.FallbackController

  def index(conn, _params) do
    decks = Model.list_decks()
    render(conn, "index.json", decks: decks)
  end

  def create(conn, %{"deck" => deck_params}) do
    with {:ok, %Deck{} = deck} <- Model.create_deck(deck_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.deck_path(conn, :show, deck))
      |> render("show.json", deck: deck)
    end
  end

  def show(conn, %{"id" => id}) do
    deck = Model.get_deck!(id)
    render(conn, "show.json", deck: deck)
  end

  def update(conn, %{"id" => id, "deck" => deck_params}) do
    deck = Model.get_deck!(id)

    with {:ok, %Deck{} = deck} <- Model.update_deck(deck, deck_params) do
      render(conn, "show.json", deck: deck)
    end
  end

  def delete(conn, %{"id" => id}) do
    deck = Model.get_deck!(id)

    with {:ok, %Deck{}} <- Model.delete_deck(deck) do
      send_resp(conn, :no_content, "")
    end
  end
end
