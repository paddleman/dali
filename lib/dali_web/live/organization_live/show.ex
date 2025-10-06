defmodule DaliWeb.OrganizationLive.Show do
  use DaliWeb, :live_view

  alias Dali.Organizations

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Organization {@organization.id}
        <:subtitle>This is a organization record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/organizations"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/organizations/#{@organization}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit organization
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@organization.name}</:item>
        <:item title="Code">{@organization.code}</:item>
        <:item title="Description">{@organization.description}</:item>
        <:item title="Active">{@organization.active}</:item>
      </.list>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Organizations.subscribe_organizations(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Organization")
     |> assign(:organization, Organizations.get_organization!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Dali.Organizations.Organization{id: id} = organization},
        %{assigns: %{organization: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :organization, organization)}
  end

  def handle_info(
        {:deleted, %Dali.Organizations.Organization{id: id}},
        %{assigns: %{organization: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current organization was deleted.")
     |> push_navigate(to: ~p"/organizations")}
  end

  def handle_info({type, %Dali.Organizations.Organization{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
