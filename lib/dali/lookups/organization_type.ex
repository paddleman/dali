defmodule Dali.Lookups.OrganizationType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organization_types" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :active, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization_type, attrs, user_scope) do
    organization_type
    |> cast(attrs, [:name, :code, :description, :active])
    |> validate_required([:name, :code, :description, :active])
    |> put_change(:user_id, user_scope.user.id)
  end
end
