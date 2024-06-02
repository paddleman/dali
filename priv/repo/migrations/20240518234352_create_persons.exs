defmodule Dali.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :first_name, :string
      add :last_name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
