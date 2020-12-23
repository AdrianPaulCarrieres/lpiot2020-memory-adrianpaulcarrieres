defmodule MemoryBackend.Model.Score do
    use Ecto.Schema

    schema "score" do
        field :score, :integer

        belongs_to :deck, MemoryBackend.Model.Deck
    end
end