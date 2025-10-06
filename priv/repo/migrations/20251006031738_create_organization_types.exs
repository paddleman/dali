defmodule Dali.Repo.Migrations.CreateOrganizationTypes do
  use Ecto.Migration

  def change do
    create table(:organization_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :code, :string
      add :description, :text
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:organization_types, [:user_id])
  end
end
