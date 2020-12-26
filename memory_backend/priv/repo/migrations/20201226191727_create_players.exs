defmodule MemoryBackend.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :player_name, :string
      add :score_id, references(:scores, on_delete: :nothing)

      timestamps()
    end

    create index(:players, [:score_id])
  end
end
