defmodule Dali.Repo.Migrations.AddPositionToTeammates do
  use Ecto.Migration

  def change do
    alter table("teammates") do
      add :position, :integer
    end


  end
end
