defmodule MemoryBackend.Repo.Migrations.CreateCarte do
  use Ecto.Migration

  def change do
    create table(:carte) do
      add :image, :string
      add :set_id, references(:set)
    end
  end
end
