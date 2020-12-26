defmodule MemoryBackend.Model.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :player_name, :string
    field :score_id, :id

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:player_name])
    |> validate_required([:player_name])
  end
end
