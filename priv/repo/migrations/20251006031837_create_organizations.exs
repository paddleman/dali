defmodule Dali.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :code, :string
      add :description, :text
      add :active, :boolean, default: false, null: false
      add :parent_id, references(:organizations, on_delete: :nothing, type: :binary_id)
      add :organization_type_id, references(:organization_types, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:organizations, [:user_id])

    create index(:organizations, [:parent_id])
    create index(:organizations, [:organization_type_id])
  end
end
