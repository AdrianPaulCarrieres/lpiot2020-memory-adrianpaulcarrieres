defmodule MemoryBackendWeb.ScoreController do
  use MemoryBackendWeb, :controller

  alias MemoryBackend.Model
  alias MemoryBackend.Model.Score

  action_fallback MemoryBackendWeb.FallbackController

  def index(conn, _params) do
    scores = Model.list_scores()
    render(conn, "index.json", scores: scores)
  end

  def create(conn, %{"score" => score_params}) do
    with {:ok, %Score{} = score} <- Model.create_score(score_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.score_path(conn, :show, score))
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
