defmodule MemoryBackend.Model.Card do
    use Ecto.Schema

    schema "card" do
        field :image, :string

        belongs_to :deck, MemoryBackend.Model.Deck
    end
end