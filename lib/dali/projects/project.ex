defmodule Dali.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dali.Projects.Teammate
  # alias Dali.People.Person

  @statuses [:planning, :active, :inactive, :closed]

  schema "projects" do
    field :project_number, :string
    field :project_name, :string
    field :start_date, :date
    field :end_date, :date
    field :status, Ecto.Enum, values: @statuses, default: :active

    has_many :teammates, Teammate,
      preload_order: [asc: :position],
      on_replace: :delete

    has_many :persons, through: [:teammates, :person]
    # many_to_many :persons, Teammate, join_through: "teammates"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:project_number, :project_name, :start_date, :end_date, :status])
    |> validate_required([:project_number, :project_name, :start_date, :status])
    |> cast_assoc(:teammates,
      with: &Teammate.changeset/3,
      sort_params: :persons_order,
      drop_params: :persons_delete
      )

  end

end
