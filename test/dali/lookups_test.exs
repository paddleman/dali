defmodule Dali.LookupsTest do
  use Dali.DataCase

  alias Dali.Lookups

  describe "organization_types" do
    alias Dali.Lookups.OrganizationType

    import Dali.AccountsFixtures, only: [user_scope_fixture: 0]
    import Dali.LookupsFixtures

    @invalid_attrs %{active: nil, code: nil, name: nil, description: nil}

    test "list_organization_types/1 returns all scoped organization_types" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)
      other_organization_type = organization_type_fixture(other_scope)
      assert Lookups.list_organization_types(scope) == [organization_type]
      assert Lookups.list_organization_types(other_scope) == [other_organization_type]
    end

    test "get_organization_type!/2 returns the organization_type with given id" do
      scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)
      other_scope = user_scope_fixture()
      assert Lookups.get_organization_type!(scope, organization_type.id) == organization_type
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_organization_type!(other_scope, organization_type.id) end
    end

    test "create_organization_type/2 with valid data creates a organization_type" do
      valid_attrs = %{active: true, code: "some code", name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %OrganizationType{} = organization_type} = Lookups.create_organization_type(scope, valid_attrs)
      assert organization_type.active == true
      assert organization_type.code == "some code"
      assert organization_type.name == "some name"
      assert organization_type.description == "some description"
      assert organization_type.user_id == scope.user.id
    end

    test "create_organization_type/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Lookups.create_organization_type(scope, @invalid_attrs)
    end

    test "update_organization_type/3 with valid data updates the organization_type" do
      scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)
      update_attrs = %{active: false, code: "some updated code", name: "some updated name", description: "some updated description"}

      assert {:ok, %OrganizationType{} = organization_type} = Lookups.update_organization_type(scope, organization_type, update_attrs)
      assert organization_type.active == false
      assert organization_type.code == "some updated code"
      assert organization_type.name == "some updated name"
      assert organization_type.description == "some updated description"
    end

    test "update_organization_type/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)

      assert_raise MatchError, fn ->
        Lookups.update_organization_type(other_scope, organization_type, %{})
      end
    end

    test "update_organization_type/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Lookups.update_organization_type(scope, organization_type, @invalid_attrs)
      assert organization_type == Lookups.get_organization_type!(scope, organization_type.id)
    end

    test "delete_organization_type/2 deletes the organization_type" do
      scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)
      assert {:ok, %OrganizationType{}} = Lookups.delete_organization_type(scope, organization_type)
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_organization_type!(scope, organization_type.id) end
    end

    test "delete_organization_type/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)
      assert_raise MatchError, fn -> Lookups.delete_organization_type(other_scope, organization_type) end
    end

    test "change_organization_type/2 returns a organization_type changeset" do
      scope = user_scope_fixture()
      organization_type = organization_type_fixture(scope)
      assert %Ecto.Changeset{} = Lookups.change_organization_type(scope, organization_type)
    end
  end

  describe "disciplines" do
    alias Dali.Lookups.Discipline

    import Dali.AccountsFixtures, only: [user_scope_fixture: 0]
    import Dali.LookupsFixtures

    @invalid_attrs %{active: nil, code: nil, name: nil, description: nil}

    test "list_disciplines/1 returns all scoped disciplines" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      discipline = discipline_fixture(scope)
      other_discipline = discipline_fixture(other_scope)
      assert Lookups.list_disciplines(scope) == [discipline]
      assert Lookups.list_disciplines(other_scope) == [other_discipline]
    end

    test "get_discipline!/2 returns the discipline with given id" do
      scope = user_scope_fixture()
      discipline = discipline_fixture(scope)
      other_scope = user_scope_fixture()
      assert Lookups.get_discipline!(scope, discipline.id) == discipline
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_discipline!(other_scope, discipline.id) end
    end

    test "create_discipline/2 with valid data creates a discipline" do
      valid_attrs = %{active: true, code: "some code", name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %Discipline{} = discipline} = Lookups.create_discipline(scope, valid_attrs)
      assert discipline.active == true
      assert discipline.code == "some code"
      assert discipline.name == "some name"
      assert discipline.description == "some description"
      assert discipline.user_id == scope.user.id
    end

    test "create_discipline/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Lookups.create_discipline(scope, @invalid_attrs)
    end

    test "update_discipline/3 with valid data updates the discipline" do
      scope = user_scope_fixture()
      discipline = discipline_fixture(scope)
      update_attrs = %{active: false, code: "some updated code", name: "some updated name", description: "some updated description"}

      assert {:ok, %Discipline{} = discipline} = Lookups.update_discipline(scope, discipline, update_attrs)
      assert discipline.active == false
      assert discipline.code == "some updated code"
      assert discipline.name == "some updated name"
      assert discipline.description == "some updated description"
    end

    test "update_discipline/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      discipline = discipline_fixture(scope)

      assert_raise MatchError, fn ->
        Lookups.update_discipline(other_scope, discipline, %{})
      end
    end

    test "update_discipline/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      discipline = discipline_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Lookups.update_discipline(scope, discipline, @invalid_attrs)
      assert discipline == Lookups.get_discipline!(scope, discipline.id)
    end

    test "delete_discipline/2 deletes the discipline" do
      scope = user_scope_fixture()
      discipline = discipline_fixture(scope)
      assert {:ok, %Discipline{}} = Lookups.delete_discipline(scope, discipline)
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_discipline!(scope, discipline.id) end
    end

    test "delete_discipline/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      discipline = discipline_fixture(scope)
      assert_raise MatchError, fn -> Lookups.delete_discipline(other_scope, discipline) end
    end

    test "change_discipline/2 returns a discipline changeset" do
      scope = user_scope_fixture()
      discipline = discipline_fixture(scope)
      assert %Ecto.Changeset{} = Lookups.change_discipline(scope, discipline)
    end
  end

  describe "task_types" do
    alias Dali.Lookups.TaskType

    import Dali.AccountsFixtures, only: [user_scope_fixture: 0]
    import Dali.LookupsFixtures

    @invalid_attrs %{active: nil, name: nil, description: nil}

    test "list_task_types/1 returns all scoped task_types" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      other_task_type = task_type_fixture(other_scope)
      assert Lookups.list_task_types(scope) == [task_type]
      assert Lookups.list_task_types(other_scope) == [other_task_type]
    end

    test "get_task_type!/2 returns the task_type with given id" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      other_scope = user_scope_fixture()
      assert Lookups.get_task_type!(scope, task_type.id) == task_type
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_task_type!(other_scope, task_type.id) end
    end

    test "create_task_type/2 with valid data creates a task_type" do
      valid_attrs = %{active: true, name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %TaskType{} = task_type} = Lookups.create_task_type(scope, valid_attrs)
      assert task_type.active == true
      assert task_type.name == "some name"
      assert task_type.description == "some description"
      assert task_type.user_id == scope.user.id
    end

    test "create_task_type/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Lookups.create_task_type(scope, @invalid_attrs)
    end

    test "update_task_type/3 with valid data updates the task_type" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      update_attrs = %{active: false, name: "some updated name", description: "some updated description"}

      assert {:ok, %TaskType{} = task_type} = Lookups.update_task_type(scope, task_type, update_attrs)
      assert task_type.active == false
      assert task_type.name == "some updated name"
      assert task_type.description == "some updated description"
    end

    test "update_task_type/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_type = task_type_fixture(scope)

      assert_raise MatchError, fn ->
        Lookups.update_task_type(other_scope, task_type, %{})
      end
    end

    test "update_task_type/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Lookups.update_task_type(scope, task_type, @invalid_attrs)
      assert task_type == Lookups.get_task_type!(scope, task_type.id)
    end

    test "delete_task_type/2 deletes the task_type" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert {:ok, %TaskType{}} = Lookups.delete_task_type(scope, task_type)
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_task_type!(scope, task_type.id) end
    end

    test "delete_task_type/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert_raise MatchError, fn -> Lookups.delete_task_type(other_scope, task_type) end
    end

    test "change_task_type/2 returns a task_type changeset" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert %Ecto.Changeset{} = Lookups.change_task_type(scope, task_type)
    end
  end

  describe "task_types" do
    alias Dali.Lookups.TaskType

    import Dali.AccountsFixtures, only: [user_scope_fixture: 0]
    import Dali.LookupsFixtures

    @invalid_attrs %{active: nil, code: nil, name: nil, description: nil}

    test "list_task_types/1 returns all scoped task_types" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      other_task_type = task_type_fixture(other_scope)
      assert Lookups.list_task_types(scope) == [task_type]
      assert Lookups.list_task_types(other_scope) == [other_task_type]
    end

    test "get_task_type!/2 returns the task_type with given id" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      other_scope = user_scope_fixture()
      assert Lookups.get_task_type!(scope, task_type.id) == task_type
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_task_type!(other_scope, task_type.id) end
    end

    test "create_task_type/2 with valid data creates a task_type" do
      valid_attrs = %{active: true, code: "some code", name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %TaskType{} = task_type} = Lookups.create_task_type(scope, valid_attrs)
      assert task_type.active == true
      assert task_type.code == "some code"
      assert task_type.name == "some name"
      assert task_type.description == "some description"
      assert task_type.user_id == scope.user.id
    end

    test "create_task_type/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Lookups.create_task_type(scope, @invalid_attrs)
    end

    test "update_task_type/3 with valid data updates the task_type" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      update_attrs = %{active: false, code: "some updated code", name: "some updated name", description: "some updated description"}

      assert {:ok, %TaskType{} = task_type} = Lookups.update_task_type(scope, task_type, update_attrs)
      assert task_type.active == false
      assert task_type.code == "some updated code"
      assert task_type.name == "some updated name"
      assert task_type.description == "some updated description"
    end

    test "update_task_type/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_type = task_type_fixture(scope)

      assert_raise MatchError, fn ->
        Lookups.update_task_type(other_scope, task_type, %{})
      end
    end

    test "update_task_type/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Lookups.update_task_type(scope, task_type, @invalid_attrs)
      assert task_type == Lookups.get_task_type!(scope, task_type.id)
    end

    test "delete_task_type/2 deletes the task_type" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert {:ok, %TaskType{}} = Lookups.delete_task_type(scope, task_type)
      assert_raise Ecto.NoResultsError, fn -> Lookups.get_task_type!(scope, task_type.id) end
    end

    test "delete_task_type/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert_raise MatchError, fn -> Lookups.delete_task_type(other_scope, task_type) end
    end

    test "change_task_type/2 returns a task_type changeset" do
      scope = user_scope_fixture()
      task_type = task_type_fixture(scope)
      assert %Ecto.Changeset{} = Lookups.change_task_type(scope, task_type)
    end
  end
end
