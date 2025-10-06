defmodule DaliWeb.TaskTypeLiveTest do
  use DaliWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dali.LookupsFixtures

  @create_attrs %{active: true, code: "some code", name: "some name", description: "some description"}
  @update_attrs %{active: false, code: "some updated code", name: "some updated name", description: "some updated description"}
  @invalid_attrs %{active: false, code: nil, name: nil, description: nil}

  setup :register_and_log_in_user

  defp create_task_type(%{scope: scope}) do
    task_type = task_type_fixture(scope)

    %{task_type: task_type}
  end

  describe "Index" do
    setup [:create_task_type]

    test "lists all task_types", %{conn: conn, task_type: task_type} do
      {:ok, _index_live, html} = live(conn, ~p"/task_types")

      assert html =~ "Listing Task types"
      assert html =~ task_type.name
    end

    test "saves new task_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/task_types")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Task type")
               |> render_click()
               |> follow_redirect(conn, ~p"/task_types/new")

      assert render(form_live) =~ "New Task type"

      assert form_live
             |> form("#task_type-form", task_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#task_type-form", task_type: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/task_types")

      html = render(index_live)
      assert html =~ "Task type created successfully"
      assert html =~ "some name"
    end

    test "updates task_type in listing", %{conn: conn, task_type: task_type} do
      {:ok, index_live, _html} = live(conn, ~p"/task_types")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#task_types-#{task_type.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/task_types/#{task_type}/edit")

      assert render(form_live) =~ "Edit Task type"

      assert form_live
             |> form("#task_type-form", task_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#task_type-form", task_type: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/task_types")

      html = render(index_live)
      assert html =~ "Task type updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes task_type in listing", %{conn: conn, task_type: task_type} do
      {:ok, index_live, _html} = live(conn, ~p"/task_types")

      assert index_live |> element("#task_types-#{task_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task_types-#{task_type.id}")
    end
  end

  describe "Show" do
    setup [:create_task_type]

    test "displays task_type", %{conn: conn, task_type: task_type} do
      {:ok, _show_live, html} = live(conn, ~p"/task_types/#{task_type}")

      assert html =~ "Show Task type"
      assert html =~ task_type.name
    end

    test "updates task_type and returns to show", %{conn: conn, task_type: task_type} do
      {:ok, show_live, _html} = live(conn, ~p"/task_types/#{task_type}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/task_types/#{task_type}/edit?return_to=show")

      assert render(form_live) =~ "Edit Task type"

      assert form_live
             |> form("#task_type-form", task_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#task_type-form", task_type: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/task_types/#{task_type}")

      html = render(show_live)
      assert html =~ "Task type updated successfully"
      assert html =~ "some updated name"
    end
  end
end
