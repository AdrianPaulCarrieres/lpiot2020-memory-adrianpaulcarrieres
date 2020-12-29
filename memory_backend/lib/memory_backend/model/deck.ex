defmodule MemoryBackend.Model.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :theme, :scores]}

  schema "decks" do
    field :card_back, :binary
    field :theme, :string

    has_many :cards, MemoryBackend.Model.Card, on_replace: :delete
    has_many :scores, MemoryBackend.Model.Score, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:theme, :card_back])
    |> cast_assoc(:cards)
    |> cast_assoc(:scores)
    |> validate_required([:theme, :card_back])
  end
end
