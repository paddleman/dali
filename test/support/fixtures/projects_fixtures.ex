defmodule Dali.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dali.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        end_date: ~D[2024-05-17],
        project_name: "some project_name",
        project_number: "some project_number",
        start_date: ~D[2024-05-17],
        status: "some status"
      })
      |> Dali.Projects.create_project()

    project
  end

  @doc """
  Generate a teammate.
  """
  def teammate_fixture(attrs \\ %{}) do
    {:ok, teammate} =
      attrs
      |> Enum.into(%{
        discipline_id: 42,
        person_id: 42,
        project_id: 42,
        responsibilties: "some responsibilties",
        role_id: 42,
        role_type: "some role_type"
      })
      |> Dali.Projects.create_teammate()

    teammate
  end
end
