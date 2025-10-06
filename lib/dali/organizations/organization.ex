defmodule Dali.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizations" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :active, :boolean, default: false
    field :parent_id, :binary_id
    field :organization_type_id, :binary_id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs, user_scope) do
    organization
    |> cast(attrs, [:name, :code, :description, :active])
    |> validate_required([:name, :code, :description, :active])
    |> put_change(:user_id, user_scope.user.id)
  end
end
