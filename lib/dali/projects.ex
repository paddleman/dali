defmodule Dali.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Dali.Repo

  alias Dali.Projects.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  alias Dali.Projects.Teammate

  @doc """
  Returns the list of teammates.

  ## Examples

      iex> list_teammates()
      [%Teammate{}, ...]

  """
  def list_teammates do
    Repo.all(Teammate)
  end

  @doc """
  Gets a single teammate.

  Raises `Ecto.NoResultsError` if the Teammate does not exist.

  ## Examples

      iex> get_teammate!(123)
      %Teammate{}

      iex> get_teammate!(456)
      ** (Ecto.NoResultsError)

  """
  def get_teammate!(id), do: Repo.get!(Teammate, id)

  @doc """
  Creates a teammate.

  ## Examples

      iex> create_teammate(%{field: value})
      {:ok, %Teammate{}}

      iex> create_teammate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_teammate(attrs \\ %{}) do
    %Teammate{}
    |> Teammate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a teammate.

  ## Examples

      iex> update_teammate(teammate, %{field: new_value})
      {:ok, %Teammate{}}

      iex> update_teammate(teammate, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_teammate(%Teammate{} = teammate, attrs) do
    teammate
    |> Teammate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a teammate.

  ## Examples

      iex> delete_teammate(teammate)
      {:ok, %Teammate{}}

      iex> delete_teammate(teammate)
      {:error, %Ecto.Changeset{}}

  """
  def delete_teammate(%Teammate{} = teammate) do
    Repo.delete(teammate)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking teammate changes.

  ## Examples

      iex> change_teammate(teammate)
      %Ecto.Changeset{data: %Teammate{}}

  """
  def change_teammate(%Teammate{} = teammate, attrs \\ %{}) do
    Teammate.changeset(teammate, attrs)
  end
end
