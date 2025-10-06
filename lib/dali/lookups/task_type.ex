defmodule Dali.Lookups.TaskType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "task_types" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :active, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task_type, attrs, user_scope) do
    task_type
    |> cast(attrs, [:name, :code, :description, :active])
    |> validate_required([:name, :code, :description, :active])
    |> put_change(:user_id, user_scope.user.id)
  end
end
