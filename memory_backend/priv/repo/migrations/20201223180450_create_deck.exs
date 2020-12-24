defmodule MemoryBackend.Repo.Migrations.CreateDeck do
  use Ecto.Migration

  def change do
    create table(:deck) do
      add :theme, :string
    end
  end
end
