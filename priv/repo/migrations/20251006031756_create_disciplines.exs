defmodule Dali.Repo.Migrations.CreateDisciplines do
  use Ecto.Migration

  def change do
    create table(:disciplines, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :code, :string
      add :description, :text
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:disciplines, [:user_id])
  end
end
