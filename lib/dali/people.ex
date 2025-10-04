defmodule Dali.People do
  @moduledoc """
  The People context.
  """

  import Ecto.Query, warn: false
  alias Dali.Repo

  alias Dali.People.Person
  alias Dali.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any person changes.

  The broadcasted messages match the pattern:

    * {:created, %Person{}}
    * {:updated, %Person{}}
    * {:deleted, %Person{}}

  """
  def subscribe_persons(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Dali.PubSub, "user:#{key}:persons")
  end

  defp broadcast_person(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Dali.PubSub, "user:#{key}:persons", message)
  end

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons(scope)
      [%Person{}, ...]

  """
  def list_persons(%Scope{} = scope) do
    Repo.all_by(Person, user_id: scope.user.id)
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(scope, 123)
      %Person{}

      iex> get_person!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(%Scope{} = scope, id) do
    Repo.get_by!(Person, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(scope, %{field: value})
      {:ok, %Person{}}

      iex> create_person(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(%Scope{} = scope, attrs) do
    with {:ok, person = %Person{}} <-
           %Person{}
           |> Person.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_person(scope, {:created, person})
      {:ok, person}
    end
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(scope, person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(scope, person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Scope{} = scope, %Person{} = person, attrs) do
    true = person.user_id == scope.user.id

    with {:ok, person = %Person{}} <-
           person
           |> Person.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_person(scope, {:updated, person})
      {:ok, person}
    end
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(scope, person)
      {:ok, %Person{}}

      iex> delete_person(scope, person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Scope{} = scope, %Person{} = person) do
    true = person.user_id == scope.user.id

    with {:ok, person = %Person{}} <-
           Repo.delete(person) do
      broadcast_person(scope, {:deleted, person})
      {:ok, person}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(scope, person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Scope{} = scope, %Person{} = person, attrs \\ %{}) do
    true = person.user_id == scope.user.id

    Person.changeset(person, attrs, scope)
  end
end
