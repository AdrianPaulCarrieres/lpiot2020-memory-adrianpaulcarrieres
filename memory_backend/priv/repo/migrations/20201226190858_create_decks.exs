defmodule MemoryBackend.Repo.Migrations.CreateDecks do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add :theme, :string
      add :card_back, :binary

      timestamps()
    end

  end
end
