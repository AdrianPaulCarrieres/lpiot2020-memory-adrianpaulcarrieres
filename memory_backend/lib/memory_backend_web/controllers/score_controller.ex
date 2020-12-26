defmodule MemoryBackendWeb.ScoreController do
  use MemoryBackendWeb, :controller

  alias MemoryBackend.Model
  alias MemoryBackend.Model.Score

  action_fallback MemoryBackendWeb.FallbackController

  def index(conn, %{"deck_id" => deck_id}) do
    deck = Model.get_deck!(deck_id)
    render(conn, "index.json", scores: deck.scores)
  end

  def create(conn, %{"deck_id" => deck_id, "score" => score_params}) do
    deck = Model.get_deck!(deck_id)

    with {:ok, %Score{} = score} <- Model.create_score(deck, score_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.deck_score_path(conn, :show, deck_id, score))
      |> render("show.json", score: score)
    end
  end

  def show(conn, %{"id" => id}) do
    score = Model.get_score!(id)
    render(conn, "show.json", score: score)
  end

  def update(conn, %{"id" => id, "score" => score_params}) do
    score = Model.get_score!(id)

    with {:ok, %Score{} = score} <- Model.update_score(score, score_params) do
      render(conn, "show.json", score: score)
    end
  end

  def delete(conn, %{"id" => id}) do
    score = Model.get_score!(id)

    with {:ok, %Score{}} <- Model.delete_score(score) do
      send_resp(conn, :no_content, "")
    end
  end
end
