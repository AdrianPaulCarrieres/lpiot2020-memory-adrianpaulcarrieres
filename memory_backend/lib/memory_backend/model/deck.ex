defmodule MemoryBackend.Model.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decks" do
    field :card_back, :binary
    field :theme, :string

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:theme, :card_back])
    |> validate_required([:theme, :card_back])
  end
end
