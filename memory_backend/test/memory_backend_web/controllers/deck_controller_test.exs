defmodule MemoryBackendWeb.DeckControllerTest do
  use MemoryBackendWeb.ConnCase

  alias MemoryBackend.Model
  alias MemoryBackend.Model.Deck

  @create_attrs %{
    card_back: "some card_back",
    theme: "some theme"
  }
  @update_attrs %{
    card_back: "some updated card_back",
    theme: "some updated theme"
  }
  @invalid_attrs %{card_back: nil, theme: nil}

  def fixture(:deck) do
    {:ok, deck} = Model.create_deck(@create_attrs)
    deck
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all decks", %{conn: conn} do
      conn = get(conn, Routes.deck_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create deck" do
    test "renders deck when data is valid", %{conn: conn} do
      conn = post(conn, Routes.deck_path(conn, :create), deck: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.deck_path(conn, :show, id))

      assert %{
               "id" => id,
               "card_back" => "some card_back",
               "theme" => "some theme"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.deck_path(conn, :create), deck: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update deck" do
    setup [:create_deck]

    test "renders deck when data is valid", %{conn: conn, deck: %Deck{id: id} = deck} do
      conn = put(conn, Routes.deck_path(conn, :update, deck), deck: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.deck_path(conn, :show, id))

      assert %{
               "id" => id,
               "card_back" => "some updated card_back",
               "theme" => "some updated theme"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, deck: deck} do
      conn = put(conn, Routes.deck_path(conn, :update, deck), deck: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete deck" do
    setup [:create_deck]

    test "deletes chosen deck", %{conn: conn, deck: deck} do
      conn = delete(conn, Routes.deck_path(conn, :delete, deck))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.deck_path(conn, :show, deck))
      end
    end
  end

  defp create_deck(_) do
    deck = fixture(:deck)
    %{deck: deck}
  end
end
