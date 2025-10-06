defmodule Dali.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dali.Organizations` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        employee_count: 42,
        established_date: ~D[2025-10-05],
        org_code: "some org_code",
        org_level: "some org_level",
        org_name: "some org_name",
        org_short_name: "some org_short_name",
        status: "some status",
        website: "some website"
      })

    {:ok, organization} = Dali.Organizations.create_organization(scope, attrs)
    organization
  end

  @doc """
  Generate a organization.
  """
  def organization_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        code: "some code",
        description: "some description",
        name: "some name"
      })

    {:ok, organization} = Dali.Organizations.create_organization(scope, attrs)
    organization
  end
end
