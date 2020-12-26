defmodule MemoryBackend.Model.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :player_name, :string
    belongs_to(:score, MemoryBackend.Model.Score)

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:player_name])
    |> validate_required([:player_name])
    |> assoc_constraint(:score)
  end
end
