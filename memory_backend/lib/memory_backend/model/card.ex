defmodule MemoryBackend.Model.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :image, :binary
    field :deck_id, :id

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:image])
    |> validate_required([:image])
  end
end
