defmodule Dali.Repo.Migrations.CreateTeammates do
  use Ecto.Migration

  def change do
    create table(:teammates) do
      add :project_id, :integer
      add :person_id, :integer
      add :discipline_id, :integer
      add :role_id, :integer
      add :role_type, :string
      add :responsibilties, :text

      timestamps(type: :utc_datetime)
    end
  end
end
