defmodule Dali.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Dali.People.Person
  alias Dali.Projects.Teammate

  schema "persons" do
    field :first_name, :string
    field :last_name, :string

    # has_many :teammates, Teammate,
    #   preload_order: [asc: :position],
    #   on_replace: :delete

    many_to_many :projects, Teammate, join_through: "teammates"


    timestamps(type: :utc_datetime)
  end



  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end
end
