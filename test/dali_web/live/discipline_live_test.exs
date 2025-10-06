defmodule DaliWeb.DisciplineLiveTest do
  use DaliWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dali.LookupsFixtures

  @create_attrs %{active: true, code: "some code", name: "some name", description: "some description"}
  @update_attrs %{active: false, code: "some updated code", name: "some updated name", description: "some updated description"}
  @invalid_attrs %{active: false, code: nil, name: nil, description: nil}

  setup :register_and_log_in_user

  defp create_discipline(%{scope: scope}) do
    discipline = discipline_fixture(scope)

    %{discipline: discipline}
  end

  describe "Index" do
    setup [:create_discipline]

    test "lists all disciplines", %{conn: conn, discipline: discipline} do
      {:ok, _index_live, html} = live(conn, ~p"/disciplines")

      assert html =~ "Listing Disciplines"
      assert html =~ discipline.name
    end

    test "saves new discipline", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/disciplines")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Discipline")
               |> render_click()
               |> follow_redirect(conn, ~p"/disciplines/new")

      assert render(form_live) =~ "New Discipline"

      assert form_live
             |> form("#discipline-form", discipline: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#discipline-form", discipline: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/disciplines")

      html = render(index_live)
      assert html =~ "Discipline created successfully"
      assert html =~ "some name"
    end

    test "updates discipline in listing", %{conn: conn, discipline: discipline} do
      {:ok, index_live, _html} = live(conn, ~p"/disciplines")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#disciplines-#{discipline.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/disciplines/#{discipline}/edit")

      assert render(form_live) =~ "Edit Discipline"

      assert form_live
             |> form("#discipline-form", discipline: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#discipline-form", discipline: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/disciplines")

      html = render(index_live)
      assert html =~ "Discipline updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes discipline in listing", %{conn: conn, discipline: discipline} do
      {:ok, index_live, _html} = live(conn, ~p"/disciplines")

      assert index_live |> element("#disciplines-#{discipline.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#disciplines-#{discipline.id}")
    end
  end

  describe "Show" do
    setup [:create_discipline]

    test "displays discipline", %{conn: conn, discipline: discipline} do
      {:ok, _show_live, html} = live(conn, ~p"/disciplines/#{discipline}")

      assert html =~ "Show Discipline"
      assert html =~ discipline.name
    end

    test "updates discipline and returns to show", %{conn: conn, discipline: discipline} do
      {:ok, show_live, _html} = live(conn, ~p"/disciplines/#{discipline}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/disciplines/#{discipline}/edit?return_to=show")

      assert render(form_live) =~ "Edit Discipline"

      assert form_live
             |> form("#discipline-form", discipline: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#discipline-form", discipline: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/disciplines/#{discipline}")

      html = render(show_live)
      assert html =~ "Discipline updated successfully"
      assert html =~ "some updated name"
    end
  end
end
