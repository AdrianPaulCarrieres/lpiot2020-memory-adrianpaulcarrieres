defmodule MemoryBackend.Model.Carte do
    use Ecto.Schema

    schema "carte" do
        field :image, :string

        belongs_to :set, MemoryBackend.Model.Set
    end
end