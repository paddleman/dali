defmodule Dali.OrganizationsTest do
  use Dali.DataCase

  alias Dali.Organizations

  describe "organizations" do
    alias Dali.Organizations.Organization

    import Dali.AccountsFixtures, only: [user_scope_fixture: 0]
    import Dali.OrganizationsFixtures

    @invalid_attrs %{status: nil, description: nil, org_name: nil, org_short_name: nil, org_level: nil, org_code: nil, established_date: nil, website: nil, employee_count: nil}

    test "list_organizations/1 returns all scoped organizations" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)
      other_organization = organization_fixture(other_scope)
      assert Organizations.list_organizations(scope) == [organization]
      assert Organizations.list_organizations(other_scope) == [other_organization]
    end

    test "get_organization!/2 returns the organization with given id" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      other_scope = user_scope_fixture()
      assert Organizations.get_organization!(scope, organization.id) == organization
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(other_scope, organization.id) end
    end

    test "create_organization/2 with valid data creates a organization" do
      valid_attrs = %{status: "some status", description: "some description", org_name: "some org_name", org_short_name: "some org_short_name", org_level: "some org_level", org_code: "some org_code", established_date: ~D[2025-10-05], website: "some website", employee_count: 42}
      scope = user_scope_fixture()

      assert {:ok, %Organization{} = organization} = Organizations.create_organization(scope, valid_attrs)
      assert organization.status == "some status"
      assert organization.description == "some description"
      assert organization.org_name == "some org_name"
      assert organization.org_short_name == "some org_short_name"
      assert organization.org_level == "some org_level"
      assert organization.org_code == "some org_code"
      assert organization.established_date == ~D[2025-10-05]
      assert organization.website == "some website"
      assert organization.employee_count == 42
      assert organization.user_id == scope.user.id
    end

    test "create_organization/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(scope, @invalid_attrs)
    end

    test "update_organization/3 with valid data updates the organization" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      update_attrs = %{status: "some updated status", description: "some updated description", org_name: "some updated org_name", org_short_name: "some updated org_short_name", org_level: "some updated org_level", org_code: "some updated org_code", established_date: ~D[2025-10-06], website: "some updated website", employee_count: 43}

      assert {:ok, %Organization{} = organization} = Organizations.update_organization(scope, organization, update_attrs)
      assert organization.status == "some updated status"
      assert organization.description == "some updated description"
      assert organization.org_name == "some updated org_name"
      assert organization.org_short_name == "some updated org_short_name"
      assert organization.org_level == "some updated org_level"
      assert organization.org_code == "some updated org_code"
      assert organization.established_date == ~D[2025-10-06]
      assert organization.website == "some updated website"
      assert organization.employee_count == 43
    end

    test "update_organization/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)

      assert_raise MatchError, fn ->
        Organizations.update_organization(other_scope, organization, %{})
      end
    end

    test "update_organization/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(scope, organization, @invalid_attrs)
      assert organization == Organizations.get_organization!(scope, organization.id)
    end

    test "delete_organization/2 deletes the organization" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert {:ok, %Organization{}} = Organizations.delete_organization(scope, organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(scope, organization.id) end
    end

    test "delete_organization/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert_raise MatchError, fn -> Organizations.delete_organization(other_scope, organization) end
    end

    test "change_organization/2 returns a organization changeset" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert %Ecto.Changeset{} = Organizations.change_organization(scope, organization)
    end
  end

  describe "organizations" do
    alias Dali.Organizations.Organization

    import Dali.AccountsFixtures, only: [user_scope_fixture: 0]
    import Dali.OrganizationsFixtures

    @invalid_attrs %{active: nil, code: nil, name: nil, description: nil}

    test "list_organizations/1 returns all scoped organizations" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)
      other_organization = organization_fixture(other_scope)
      assert Organizations.list_organizations(scope) == [organization]
      assert Organizations.list_organizations(other_scope) == [other_organization]
    end

    test "get_organization!/2 returns the organization with given id" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      other_scope = user_scope_fixture()
      assert Organizations.get_organization!(scope, organization.id) == organization
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(other_scope, organization.id) end
    end

    test "create_organization/2 with valid data creates a organization" do
      valid_attrs = %{active: true, code: "some code", name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %Organization{} = organization} = Organizations.create_organization(scope, valid_attrs)
      assert organization.active == true
      assert organization.code == "some code"
      assert organization.name == "some name"
      assert organization.description == "some description"
      assert organization.user_id == scope.user.id
    end

    test "create_organization/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(scope, @invalid_attrs)
    end

    test "update_organization/3 with valid data updates the organization" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      update_attrs = %{active: false, code: "some updated code", name: "some updated name", description: "some updated description"}

      assert {:ok, %Organization{} = organization} = Organizations.update_organization(scope, organization, update_attrs)
      assert organization.active == false
      assert organization.code == "some updated code"
      assert organization.name == "some updated name"
      assert organization.description == "some updated description"
    end

    test "update_organization/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)

      assert_raise MatchError, fn ->
        Organizations.update_organization(other_scope, organization, %{})
      end
    end

    test "update_organization/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(scope, organization, @invalid_attrs)
      assert organization == Organizations.get_organization!(scope, organization.id)
    end

    test "delete_organization/2 deletes the organization" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert {:ok, %Organization{}} = Organizations.delete_organization(scope, organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(scope, organization.id) end
    end

    test "delete_organization/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert_raise MatchError, fn -> Organizations.delete_organization(other_scope, organization) end
    end

    test "change_organization/2 returns a organization changeset" do
      scope = user_scope_fixture()
      organization = organization_fixture(scope)
      assert %Ecto.Changeset{} = Organizations.change_organization(scope, organization)
    end
  end
end
