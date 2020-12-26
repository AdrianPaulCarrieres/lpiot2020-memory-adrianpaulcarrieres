defmodule MemoryBackend.Model.Deck do
  use Ecto.Schema
  import Ecto.Query

  schema "deck" do
    field :theme, :string

    has_many :card, MemoryBackend.Model.Card
    has_many :score, MemoryBackend.Model.Score
  end

  def get_associated_cards(%MemoryBackend.Model.Deck{theme: theme}) do
    MemoryBackend.Repo.one(
      from d in MemoryBackend.Model.Deck, where: d.theme == ^theme, preload: [:card]
    )
  end

  def get_deck_with_cards_and_high_scores(%MemoryBackend.Model.Deck{id: id}) do
    MemoryBackend.Repo.one(
      from d in MemoryBackend.Model.Deck, where: d.id == ^id, preload: [:card, :score]
    )
  end

  def get_deck_with_cards_and_high_scores(%MemoryBackend.Model.Deck{theme: theme}) do
    MemoryBackend.Repo.one(
      from d in MemoryBackend.Model.Deck, where: d.theme == ^theme, preload: [:card, :score]
    )
  end

  def get_associated_high_scores(%MemoryBackend.Model.Deck{id: id}) do
    MemoryBackend.Repo.one(
      from d in MemoryBackend.Model.Deck, where: d.id == ^id, preload: [:score]
    )
  end

  def get_associated_high_scores(%MemoryBackend.Model.Deck{theme: theme}) do
    MemoryBackend.Repo.one(
      from d in MemoryBackend.Model.Deck, where: d.theme == ^theme, preload: [:score]
    )
  end

  def get_all_decks_with_high_scores() do
    MemoryBackend.Repo.all(from d in MemoryBackend.Model.Deck, preload: [:score])
  end
end
