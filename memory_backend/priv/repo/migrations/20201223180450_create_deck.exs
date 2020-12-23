defmodule MemoryBackend.Repo.Migrations.CreateDeck do
  use Ecto.Migration

  def change do
    create table(:deck) do
      add :label, :string
    end
  end
end
