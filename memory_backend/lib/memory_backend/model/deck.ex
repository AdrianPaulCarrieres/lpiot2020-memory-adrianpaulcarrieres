defmodule MemoryBackend.Model.Deck do
    use Ecto.Schema

    schema "deck" do
        field :label, :string

        has_many :card, MemoryBackend.Model.Card
        has_many :score, MemoryBackend.Model.Score
    end
end