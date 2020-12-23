defmodule MemoryBackend.Model.Score do
    use Ecto.Schema

    schema "score" do
        field :score, :integer

        belongs_to :set, MemoryBackend.Model.Set
    end
end