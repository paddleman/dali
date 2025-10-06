defmodule Dali.Lookups do
  @moduledoc """
  The Lookups context.
  """

  import Ecto.Query, warn: false
  alias Dali.Repo

  alias Dali.Lookups.OrganizationType
  alias Dali.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any organization_type changes.

  The broadcasted messages match the pattern:

    * {:created, %OrganizationType{}}
    * {:updated, %OrganizationType{}}
    * {:deleted, %OrganizationType{}}

  """
  def subscribe_organization_types(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Dali.PubSub, "user:#{key}:organization_types")
  end

  defp broadcast_organization_type(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Dali.PubSub, "user:#{key}:organization_types", message)
  end

  @doc """
  Returns the list of organization_types.

  ## Examples

      iex> list_organization_types(scope)
      [%OrganizationType{}, ...]

  """
  def list_organization_types(%Scope{} = scope) do
    Repo.all_by(OrganizationType, user_id: scope.user.id)
  end

  @doc """
  Gets a single organization_type.

  Raises `Ecto.NoResultsError` if the Organization type does not exist.

  ## Examples

      iex> get_organization_type!(scope, 123)
      %OrganizationType{}

      iex> get_organization_type!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_organization_type!(%Scope{} = scope, id) do
    Repo.get_by!(OrganizationType, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a organization_type.

  ## Examples

      iex> create_organization_type(scope, %{field: value})
      {:ok, %OrganizationType{}}

      iex> create_organization_type(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization_type(%Scope{} = scope, attrs) do
    with {:ok, organization_type = %OrganizationType{}} <-
           %OrganizationType{}
           |> OrganizationType.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_organization_type(scope, {:created, organization_type})
      {:ok, organization_type}
    end
  end

  @doc """
  Updates a organization_type.

  ## Examples

      iex> update_organization_type(scope, organization_type, %{field: new_value})
      {:ok, %OrganizationType{}}

      iex> update_organization_type(scope, organization_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization_type(%Scope{} = scope, %OrganizationType{} = organization_type, attrs) do
    true = organization_type.user_id == scope.user.id

    with {:ok, organization_type = %OrganizationType{}} <-
           organization_type
           |> OrganizationType.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_organization_type(scope, {:updated, organization_type})
      {:ok, organization_type}
    end
  end

  @doc """
  Deletes a organization_type.

  ## Examples

      iex> delete_organization_type(scope, organization_type)
      {:ok, %OrganizationType{}}

      iex> delete_organization_type(scope, organization_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization_type(%Scope{} = scope, %OrganizationType{} = organization_type) do
    true = organization_type.user_id == scope.user.id

    with {:ok, organization_type = %OrganizationType{}} <-
           Repo.delete(organization_type) do
      broadcast_organization_type(scope, {:deleted, organization_type})
      {:ok, organization_type}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization_type changes.

  ## Examples

      iex> change_organization_type(scope, organization_type)
      %Ecto.Changeset{data: %OrganizationType{}}

  """
  def change_organization_type(%Scope{} = scope, %OrganizationType{} = organization_type, attrs \\ %{}) do
    true = organization_type.user_id == scope.user.id

    OrganizationType.changeset(organization_type, attrs, scope)
  end

  alias Dali.Lookups.Discipline
  alias Dali.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any discipline changes.

  The broadcasted messages match the pattern:

    * {:created, %Discipline{}}
    * {:updated, %Discipline{}}
    * {:deleted, %Discipline{}}

  """
  def subscribe_disciplines(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Dali.PubSub, "user:#{key}:disciplines")
  end

  defp broadcast_discipline(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Dali.PubSub, "user:#{key}:disciplines", message)
  end

  @doc """
  Returns the list of disciplines.

  ## Examples

      iex> list_disciplines(scope)
      [%Discipline{}, ...]

  """
  def list_disciplines(%Scope{} = scope) do
    Repo.all_by(Discipline, user_id: scope.user.id)
  end

  @doc """
  Gets a single discipline.

  Raises `Ecto.NoResultsError` if the Discipline does not exist.

  ## Examples

      iex> get_discipline!(scope, 123)
      %Discipline{}

      iex> get_discipline!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_discipline!(%Scope{} = scope, id) do
    Repo.get_by!(Discipline, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a discipline.

  ## Examples

      iex> create_discipline(scope, %{field: value})
      {:ok, %Discipline{}}

      iex> create_discipline(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discipline(%Scope{} = scope, attrs) do
    with {:ok, discipline = %Discipline{}} <-
           %Discipline{}
           |> Discipline.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_discipline(scope, {:created, discipline})
      {:ok, discipline}
    end
  end

  @doc """
  Updates a discipline.

  ## Examples

      iex> update_discipline(scope, discipline, %{field: new_value})
      {:ok, %Discipline{}}

      iex> update_discipline(scope, discipline, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discipline(%Scope{} = scope, %Discipline{} = discipline, attrs) do
    true = discipline.user_id == scope.user.id

    with {:ok, discipline = %Discipline{}} <-
           discipline
           |> Discipline.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_discipline(scope, {:updated, discipline})
      {:ok, discipline}
    end
  end

  @doc """
  Deletes a discipline.

  ## Examples

      iex> delete_discipline(scope, discipline)
      {:ok, %Discipline{}}

      iex> delete_discipline(scope, discipline)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discipline(%Scope{} = scope, %Discipline{} = discipline) do
    true = discipline.user_id == scope.user.id

    with {:ok, discipline = %Discipline{}} <-
           Repo.delete(discipline) do
      broadcast_discipline(scope, {:deleted, discipline})
      {:ok, discipline}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discipline changes.

  ## Examples

      iex> change_discipline(scope, discipline)
      %Ecto.Changeset{data: %Discipline{}}

  """
  def change_discipline(%Scope{} = scope, %Discipline{} = discipline, attrs \\ %{}) do
    true = discipline.user_id == scope.user.id

    Discipline.changeset(discipline, attrs, scope)
  end

  alias Dali.Lookups.TaskType
  alias Dali.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any task_type changes.

  The broadcasted messages match the pattern:

    * {:created, %TaskType{}}
    * {:updated, %TaskType{}}
    * {:deleted, %TaskType{}}

  """
  def subscribe_task_types(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Dali.PubSub, "user:#{key}:task_types")
  end

  defp broadcast_task_type(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Dali.PubSub, "user:#{key}:task_types", message)
  end

  @doc """
  Returns the list of task_types.

  ## Examples

      iex> list_task_types(scope)
      [%TaskType{}, ...]

  """
  def list_task_types(%Scope{} = scope) do
    Repo.all_by(TaskType, user_id: scope.user.id)
  end

  @doc """
  Gets a single task_type.

  Raises `Ecto.NoResultsError` if the Task type does not exist.

  ## Examples

      iex> get_task_type!(scope, 123)
      %TaskType{}

      iex> get_task_type!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_task_type!(%Scope{} = scope, id) do
    Repo.get_by!(TaskType, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a task_type.

  ## Examples

      iex> create_task_type(scope, %{field: value})
      {:ok, %TaskType{}}

      iex> create_task_type(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_type(%Scope{} = scope, attrs) do
    with {:ok, task_type = %TaskType{}} <-
           %TaskType{}
           |> TaskType.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_task_type(scope, {:created, task_type})
      {:ok, task_type}
    end
  end

  @doc """
  Updates a task_type.

  ## Examples

      iex> update_task_type(scope, task_type, %{field: new_value})
      {:ok, %TaskType{}}

      iex> update_task_type(scope, task_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_type(%Scope{} = scope, %TaskType{} = task_type, attrs) do
    true = task_type.user_id == scope.user.id

    with {:ok, task_type = %TaskType{}} <-
           task_type
           |> TaskType.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_task_type(scope, {:updated, task_type})
      {:ok, task_type}
    end
  end

  @doc """
  Deletes a task_type.

  ## Examples

      iex> delete_task_type(scope, task_type)
      {:ok, %TaskType{}}

      iex> delete_task_type(scope, task_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_type(%Scope{} = scope, %TaskType{} = task_type) do
    true = task_type.user_id == scope.user.id

    with {:ok, task_type = %TaskType{}} <-
           Repo.delete(task_type) do
      broadcast_task_type(scope, {:deleted, task_type})
      {:ok, task_type}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_type changes.

  ## Examples

      iex> change_task_type(scope, task_type)
      %Ecto.Changeset{data: %TaskType{}}

  """
  def change_task_type(%Scope{} = scope, %TaskType{} = task_type, attrs \\ %{}) do
    true = task_type.user_id == scope.user.id

    TaskType.changeset(task_type, attrs, scope)
  end
end
