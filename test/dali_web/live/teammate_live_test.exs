defmodule DaliWeb.TeammateLiveTest do
  use DaliWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dali.ProjectsFixtures

  @create_attrs %{project_id: 42, person_id: 42, discipline_id: 42, role_id: 42, role_type: "some role_type", responsibilties: "some responsibilties"}
  @update_attrs %{project_id: 43, person_id: 43, discipline_id: 43, role_id: 43, role_type: "some updated role_type", responsibilties: "some updated responsibilties"}
  @invalid_attrs %{project_id: nil, person_id: nil, discipline_id: nil, role_id: nil, role_type: nil, responsibilties: nil}

  defp create_teammate(_) do
    teammate = teammate_fixture()
    %{teammate: teammate}
  end

  describe "Index" do
    setup [:create_teammate]

    test "lists all teammates", %{conn: conn, teammate: teammate} do
      {:ok, _index_live, html} = live(conn, ~p"/teammates")

      assert html =~ "Listing Teammates"
      assert html =~ teammate.role_type
    end

    test "saves new teammate", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/teammates")

      assert index_live |> element("a", "New Teammate") |> render_click() =~
               "New Teammate"

      assert_patch(index_live, ~p"/teammates/new")

      assert index_live
             |> form("#teammate-form", teammate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#teammate-form", teammate: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/teammates")

      html = render(index_live)
      assert html =~ "Teammate created successfully"
      assert html =~ "some role_type"
    end

    test "updates teammate in listing", %{conn: conn, teammate: teammate} do
      {:ok, index_live, _html} = live(conn, ~p"/teammates")

      assert index_live |> element("#teammates-#{teammate.id} a", "Edit") |> render_click() =~
               "Edit Teammate"

      assert_patch(index_live, ~p"/teammates/#{teammate}/edit")

      assert index_live
             |> form("#teammate-form", teammate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#teammate-form", teammate: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/teammates")

      html = render(index_live)
      assert html =~ "Teammate updated successfully"
      assert html =~ "some updated role_type"
    end

    test "deletes teammate in listing", %{conn: conn, teammate: teammate} do
      {:ok, index_live, _html} = live(conn, ~p"/teammates")

      assert index_live |> element("#teammates-#{teammate.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#teammates-#{teammate.id}")
    end
  end

  describe "Show" do
    setup [:create_teammate]

    test "displays teammate", %{conn: conn, teammate: teammate} do
      {:ok, _show_live, html} = live(conn, ~p"/teammates/#{teammate}")

      assert html =~ "Show Teammate"
      assert html =~ teammate.role_type
    end

    test "updates teammate within modal", %{conn: conn, teammate: teammate} do
      {:ok, show_live, _html} = live(conn, ~p"/teammates/#{teammate}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Teammate"

      assert_patch(show_live, ~p"/teammates/#{teammate}/show/edit")

      assert show_live
             |> form("#teammate-form", teammate: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#teammate-form", teammate: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/teammates/#{teammate}")

      html = render(show_live)
      assert html =~ "Teammate updated successfully"
      assert html =~ "some updated role_type"
    end
  end
end
