defmodule MemoryBackend.Model.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :score, :integer
    field :deck_id, :id

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:score])
    |> validate_required([:score])
  end
end
