defmodule Dali.Projects.Teammate do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Dali.People.Person
  alias Dali.Projects.Project

  schema "teammates" do
    # field :project_id, :integer
    # field :person_id, :integer
    field :discipline_id, :integer
    field :role_id, :integer
    field :role_type, :string
    field :responsibilties, :string

    field :position, :integer

    belongs_to :project, Project, primary_key: true
    belongs_to :person, Persons, primary_key: true


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(teammate, attrs, position) do
    teammate
    |> cast(attrs, [:project_id, :person_id, :discipline_id, :role_id, :role_type, :responsibilties])
    |> validate_required([:project_id, :person_id ])
    |> change(position: position)


  end
end
