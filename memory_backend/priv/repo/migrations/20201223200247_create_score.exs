defmodule MemoryBackend.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:score) do
      add :score, :integer
      add :set_id, references(:set)
    end
  end
end
