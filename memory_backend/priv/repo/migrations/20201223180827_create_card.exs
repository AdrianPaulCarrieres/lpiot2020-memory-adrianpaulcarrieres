defmodule MemoryBackend.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:card) do
      add :image, :string
      add :deck_id, references(:deck)
    end
  end
end
