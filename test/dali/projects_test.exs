defmodule Dali.ProjectsTest do
  use Dali.DataCase

  alias Dali.Projects

  describe "projects" do
    alias Dali.Projects.Project

    import Dali.ProjectsFixtures

    @invalid_attrs %{status: nil, project_number: nil, project_name: nil, start_date: nil, end_date: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{status: "some status", project_number: "some project_number", project_name: "some project_name", start_date: ~D[2024-05-17], end_date: ~D[2024-05-17]}

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.status == "some status"
      assert project.project_number == "some project_number"
      assert project.project_name == "some project_name"
      assert project.start_date == ~D[2024-05-17]
      assert project.end_date == ~D[2024-05-17]
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{status: "some updated status", project_number: "some updated project_number", project_name: "some updated project_name", start_date: ~D[2024-05-18], end_date: ~D[2024-05-18]}

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.status == "some updated status"
      assert project.project_number == "some updated project_number"
      assert project.project_name == "some updated project_name"
      assert project.start_date == ~D[2024-05-18]
      assert project.end_date == ~D[2024-05-18]
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end

  describe "teammates" do
    alias Dali.Projects.Teammate

    import Dali.ProjectsFixtures

    @invalid_attrs %{project_id: nil, person_id: nil, discipline_id: nil, role_id: nil, role_type: nil, responsibilties: nil}

    test "list_teammates/0 returns all teammates" do
      teammate = teammate_fixture()
      assert Projects.list_teammates() == [teammate]
    end

    test "get_teammate!/1 returns the teammate with given id" do
      teammate = teammate_fixture()
      assert Projects.get_teammate!(teammate.id) == teammate
    end

    test "create_teammate/1 with valid data creates a teammate" do
      valid_attrs = %{project_id: 42, person_id: 42, discipline_id: 42, role_id: 42, role_type: "some role_type", responsibilties: "some responsibilties"}

      assert {:ok, %Teammate{} = teammate} = Projects.create_teammate(valid_attrs)
      assert teammate.project_id == 42
      assert teammate.person_id == 42
      assert teammate.discipline_id == 42
      assert teammate.role_id == 42
      assert teammate.role_type == "some role_type"
      assert teammate.responsibilties == "some responsibilties"
    end

    test "create_teammate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_teammate(@invalid_attrs)
    end

    test "update_teammate/2 with valid data updates the teammate" do
      teammate = teammate_fixture()
      update_attrs = %{project_id: 43, person_id: 43, discipline_id: 43, role_id: 43, role_type: "some updated role_type", responsibilties: "some updated responsibilties"}

      assert {:ok, %Teammate{} = teammate} = Projects.update_teammate(teammate, update_attrs)
      assert teammate.project_id == 43
      assert teammate.person_id == 43
      assert teammate.discipline_id == 43
      assert teammate.role_id == 43
      assert teammate.role_type == "some updated role_type"
      assert teammate.responsibilties == "some updated responsibilties"
    end

    test "update_teammate/2 with invalid data returns error changeset" do
      teammate = teammate_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_teammate(teammate, @invalid_attrs)
      assert teammate == Projects.get_teammate!(teammate.id)
    end

    test "delete_teammate/1 deletes the teammate" do
      teammate = teammate_fixture()
      assert {:ok, %Teammate{}} = Projects.delete_teammate(teammate)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_teammate!(teammate.id) end
    end

    test "change_teammate/1 returns a teammate changeset" do
      teammate = teammate_fixture()
      assert %Ecto.Changeset{} = Projects.change_teammate(teammate)
    end
  end
end
