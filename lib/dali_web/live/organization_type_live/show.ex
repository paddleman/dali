defmodule DaliWeb.OrganizationTypeLive.Show do
  use DaliWeb, :live_view

  alias Dali.Lookups

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Organization type {@organization_type.id}
        <:subtitle>This is a organization_type record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/organization_types"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/organization_types/#{@organization_type}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit organization_type
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@organization_type.name}</:item>
        <:item title="Code">{@organization_type.code}</:item>
        <:item title="Description">{@organization_type.description}</:item>
        <:item title="Active">{@organization_type.active}</:item>
      </.list>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Lookups.subscribe_organization_types(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Organization type")
     |> assign(:organization_type, Lookups.get_organization_type!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Dali.Lookups.OrganizationType{id: id} = organization_type},
        %{assigns: %{organization_type: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :organization_type, organization_type)}
  end

  def handle_info(
        {:deleted, %Dali.Lookups.OrganizationType{id: id}},
        %{assigns: %{organization_type: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current organization_type was deleted.")
     |> push_navigate(to: ~p"/organization_types")}
  end

  def handle_info({type, %Dali.Lookups.OrganizationType{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
