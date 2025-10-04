defmodule Dali.PeopleTest do
  use Dali.DataCase

  alias Dali.People

  describe "persons" do
    alias Dali.People.Person

    import Dali.AccountsFixtures, only: [user_scope_fixture: 0]
    import Dali.PeopleFixtures

    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_persons/1 returns all scoped persons" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      person = person_fixture(scope)
      other_person = person_fixture(other_scope)
      assert People.list_persons(scope) == [person]
      assert People.list_persons(other_scope) == [other_person]
    end

    test "get_person!/2 returns the person with given id" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      other_scope = user_scope_fixture()
      assert People.get_person!(scope, person.id) == person
      assert_raise Ecto.NoResultsError, fn -> People.get_person!(other_scope, person.id) end
    end

    test "create_person/2 with valid data creates a person" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name"}
      scope = user_scope_fixture()

      assert {:ok, %Person{} = person} = People.create_person(scope, valid_attrs)
      assert person.first_name == "some first_name"
      assert person.last_name == "some last_name"
      assert person.user_id == scope.user.id
    end

    test "create_person/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = People.create_person(scope, @invalid_attrs)
    end

    test "update_person/3 with valid data updates the person" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name"}

      assert {:ok, %Person{} = person} = People.update_person(scope, person, update_attrs)
      assert person.first_name == "some updated first_name"
      assert person.last_name == "some updated last_name"
    end

    test "update_person/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      person = person_fixture(scope)

      assert_raise MatchError, fn ->
        People.update_person(other_scope, person, %{})
      end
    end

    test "update_person/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = People.update_person(scope, person, @invalid_attrs)
      assert person == People.get_person!(scope, person.id)
    end

    test "delete_person/2 deletes the person" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert {:ok, %Person{}} = People.delete_person(scope, person)
      assert_raise Ecto.NoResultsError, fn -> People.get_person!(scope, person.id) end
    end

    test "delete_person/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      person = person_fixture(scope)
      assert_raise MatchError, fn -> People.delete_person(other_scope, person) end
    end

    test "change_person/2 returns a person changeset" do
      scope = user_scope_fixture()
      person = person_fixture(scope)
      assert %Ecto.Changeset{} = People.change_person(scope, person)
    end
  end
end
