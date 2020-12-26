defmodule MemoryBackend.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :score, :integer
      add :deck_id, references(:decks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:scores, [:deck_id])
  end
end
