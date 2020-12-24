defmodule MemoryBackend.Model.Deck do
    use Ecto.Schema
    import Ecto.Query

    schema "deck" do
        field :theme, :string

        has_many :card, MemoryBackend.Model.Card
        has_many :score, MemoryBackend.Model.Score
    end
    
    def get_associated_cards(theme) do
        MemoryBackend.Repo.one from d in MemoryBackend.Model.Deck, where: d.label == ^theme, preload: [:card]
    end

    def get_associated_high_scores(theme) do
        MemoryBackend.Repo.one from d in MemoryBackend.Model.Deck, where: d.label == ^theme, preload: [:score]
    end
end