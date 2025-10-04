defmodule DaliWeb.PersonLiveTest do
  use DaliWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dali.PeopleFixtures

  @create_attrs %{first_name: "some first_name", last_name: "some last_name"}
  @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
  @invalid_attrs %{first_name: nil, last_name: nil}

  setup :register_and_log_in_user

  defp create_person(%{scope: scope}) do
    person = person_fixture(scope)

    %{person: person}
  end

  describe "Index" do
    setup [:create_person]

    test "lists all persons", %{conn: conn, person: person} do
      {:ok, _index_live, html} = live(conn, ~p"/persons")

      assert html =~ "Listing Persons"
      assert html =~ person.first_name
    end

    test "saves new person", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Person")
               |> render_click()
               |> follow_redirect(conn, ~p"/persons/new")

      assert render(form_live) =~ "New Person"

      assert form_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#person-form", person: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/persons")

      html = render(index_live)
      assert html =~ "Person created successfully"
      assert html =~ "some first_name"
    end

    test "updates person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#persons-#{person.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/persons/#{person}/edit")

      assert render(form_live) =~ "Edit Person"

      assert form_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#person-form", person: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/persons")

      html = render(index_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated first_name"
    end

    test "deletes person in listing", %{conn: conn, person: person} do
      {:ok, index_live, _html} = live(conn, ~p"/persons")

      assert index_live |> element("#persons-#{person.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#persons-#{person.id}")
    end
  end

  describe "Show" do
    setup [:create_person]

    test "displays person", %{conn: conn, person: person} do
      {:ok, _show_live, html} = live(conn, ~p"/persons/#{person}")

      assert html =~ "Show Person"
      assert html =~ person.first_name
    end

    test "updates person and returns to show", %{conn: conn, person: person} do
      {:ok, show_live, _html} = live(conn, ~p"/persons/#{person}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/persons/#{person}/edit?return_to=show")

      assert render(form_live) =~ "Edit Person"

      assert form_live
             |> form("#person-form", person: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#person-form", person: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/persons/#{person}")

      html = render(show_live)
      assert html =~ "Person updated successfully"
      assert html =~ "some updated first_name"
    end
  end
end
