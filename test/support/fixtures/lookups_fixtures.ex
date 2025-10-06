defmodule Dali.LookupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dali.Lookups` context.
  """

  @doc """
  Generate a organization_type.
  """
  def organization_type_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        code: "some code",
        description: "some description",
        name: "some name"
      })

    {:ok, organization_type} = Dali.Lookups.create_organization_type(scope, attrs)
    organization_type
  end

  @doc """
  Generate a discipline.
  """
  def discipline_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        code: "some code",
        description: "some description",
        name: "some name"
      })

    {:ok, discipline} = Dali.Lookups.create_discipline(scope, attrs)
    discipline
  end

  @doc """
  Generate a task_type.
  """
  def task_type_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        description: "some description",
        name: "some name"
      })

    {:ok, task_type} = Dali.Lookups.create_task_type(scope, attrs)
    task_type
  end

  @doc """
  Generate a task_type.
  """
  def task_type_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        code: "some code",
        description: "some description",
        name: "some name"
      })

    {:ok, task_type} = Dali.Lookups.create_task_type(scope, attrs)
    task_type
  end
end
