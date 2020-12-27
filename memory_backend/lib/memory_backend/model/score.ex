defmodule MemoryBackend.Model.Score do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :deck_id, :score, :players]}

  schema "scores" do
    field :score, :integer

    belongs_to(:deck, MemoryBackend.Model.Deck)

    has_many :players, MemoryBackend.Model.Player, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:score])
    |> cast_assoc(:players)
    |> validate_required([:score])
    |> assoc_constraint(:deck)
  end
end
