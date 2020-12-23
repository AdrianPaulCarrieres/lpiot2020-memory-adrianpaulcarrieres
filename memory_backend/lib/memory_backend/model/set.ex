defmodule MemoryBackend.Model.Set do
    use Ecto.Schema

    schema "set" do
        field :label, :string

        has_many :carte, MemoryBackend.Model.Carte
        has_many :score, MemoryBackend.Model.Score
    end
end