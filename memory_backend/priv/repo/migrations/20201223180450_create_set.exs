defmodule MemoryBackend.Repo.Migrations.CreateSet do
  use Ecto.Migration

  def change do
    create table(:set) do
      add :label, :string
    end
  end
end
