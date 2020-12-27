defmodule MemoryBackend.Model.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :deck_id]}

  schema "cards" do
    field :image, :binary
    belongs_to(:deck, MemoryBackend.Model.Deck)

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:image])
    |> validate_required([:image])
    |> assoc_constraint(:deck)
  end
end
