defmodule DaliWeb.OrganizationTypeLiveTest do
  use DaliWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dali.LookupsFixtures

  @create_attrs %{active: true, code: "some code", name: "some name", description: "some description"}
  @update_attrs %{active: false, code: "some updated code", name: "some updated name", description: "some updated description"}
  @invalid_attrs %{active: false, code: nil, name: nil, description: nil}

  setup :register_and_log_in_user

  defp create_organization_type(%{scope: scope}) do
    organization_type = organization_type_fixture(scope)

    %{organization_type: organization_type}
  end

  describe "Index" do
    setup [:create_organization_type]

    test "lists all organization_types", %{conn: conn, organization_type: organization_type} do
      {:ok, _index_live, html} = live(conn, ~p"/organization_types")

      assert html =~ "Listing Organization types"
      assert html =~ organization_type.name
    end

    test "saves new organization_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/organization_types")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Organization type")
               |> render_click()
               |> follow_redirect(conn, ~p"/organization_types/new")

      assert render(form_live) =~ "New Organization type"

      assert form_live
             |> form("#organization_type-form", organization_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#organization_type-form", organization_type: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/organization_types")

      html = render(index_live)
      assert html =~ "Organization type created successfully"
      assert html =~ "some name"
    end

    test "updates organization_type in listing", %{conn: conn, organization_type: organization_type} do
      {:ok, index_live, _html} = live(conn, ~p"/organization_types")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#organization_types-#{organization_type.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/organization_types/#{organization_type}/edit")

      assert render(form_live) =~ "Edit Organization type"

      assert form_live
             |> form("#organization_type-form", organization_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#organization_type-form", organization_type: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/organization_types")

      html = render(index_live)
      assert html =~ "Organization type updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes organization_type in listing", %{conn: conn, organization_type: organization_type} do
      {:ok, index_live, _html} = live(conn, ~p"/organization_types")

      assert index_live |> element("#organization_types-#{organization_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#organization_types-#{organization_type.id}")
    end
  end

  describe "Show" do
    setup [:create_organization_type]

    test "displays organization_type", %{conn: conn, organization_type: organization_type} do
      {:ok, _show_live, html} = live(conn, ~p"/organization_types/#{organization_type}")

      assert html =~ "Show Organization type"
      assert html =~ organization_type.name
    end

    test "updates organization_type and returns to show", %{conn: conn, organization_type: organization_type} do
      {:ok, show_live, _html} = live(conn, ~p"/organization_types/#{organization_type}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/organization_types/#{organization_type}/edit?return_to=show")

      assert render(form_live) =~ "Edit Organization type"

      assert form_live
             |> form("#organization_type-form", organization_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#organization_type-form", organization_type: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/organization_types/#{organization_type}")

      html = render(show_live)
      assert html =~ "Organization type updated successfully"
      assert html =~ "some updated name"
    end
  end
end
