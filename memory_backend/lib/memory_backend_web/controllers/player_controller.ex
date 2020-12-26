defmodule MemoryBackendWeb.PlayerController do
  use MemoryBackendWeb, :controller

  alias MemoryBackend.Model
  alias MemoryBackend.Model.Player

  action_fallback MemoryBackendWeb.FallbackController

  def index(%{"score_id" => score_id}, conn, _params) do
    score = Model.get_score!(score_id)
    render(conn, "index.json", players: score.players)
  end

  def create(conn, %{"score_id" => score_id, "player" => player_params}) do
    score = Model.get_score!(score_id)

    with {:ok, %Player{} = player} <- Model.create_player(score, player_params) do
      conn
      |> put_status(:created)
      |> render("show.json", player: player)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Model.get_player!(id)
    render(conn, "show.json", player: player)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Model.get_player!(id)

    with {:ok, %Player{} = player} <- Model.update_player(player, player_params) do
      render(conn, "show.json", player: player)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Model.get_player!(id)

    with {:ok, %Player{}} <- Model.delete_player(player) do
      send_resp(conn, :no_content, "")
    end
  end
end
