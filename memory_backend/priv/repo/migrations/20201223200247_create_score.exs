defmodule MemoryBackend.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:score) do
      add :score, :integer
      add :deck_id, references(:deck)
    end
  end
end
