defmodule DaliWeb.OrganizationTypeLive.Index do
  use DaliWeb, :live_view

  alias Dali.Lookups
  alias Dali.Lookups.OrganizationType

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <div class="w-3/4 mx-auto ">
      <.header class="">
        Organization Types (Lookup)
        <:actions>
          <.button variant="primary" phx-click="show_modal" phx-value-action="new">
            <.icon name="hero-plus" /> New Organization Type
          </.button>
        </:actions>
      </.header>

      <.table class=""
        id="organization_types"
        rows={@streams.organization_types}
        row_click={fn {_id, organization_type} -> JS.navigate(~p"/organization_types/#{organization_type}") end}
      >
        <:col :let={{_id, organization_type}} label="Name">{organization_type.name}</:col>
        <:col :let={{_id, organization_type}} label="Code">{organization_type.code}</:col>
        <:col :let={{_id, organization_type}} label="Description">{organization_type.description}</:col>
        <:col :let={{_id, organization_type}} label="Active">{organization_type.active}</:col>
        <:action :let={{_id, organization_type}}>
          <div class="sr-only">
            <.link navigate={~p"/organization_types/#{organization_type}"}>Show</.link>
          </div>
          <.button phx-click="show_modal" phx-value-action="edit" phx-value-id={organization_type.id}>
            Edit
          </.button>
        </:action>
        <:action :let={{id, organization_type}}>
          <.link
            phx-click={JS.push("delete", value: %{id: organization_type.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
      </div>

      <!-- DaisyUI Modal for Form -->
      <%= if @show_modal do %>
        <div class="modal modal-open">
          <div class="modal-box">
            <h3 class="font-bold text-lg">{@modal_title}</h3>

            <.form :if={@form} for={@form} id="organization_type-modal-form" phx-change="validate" phx-submit="save">
              <.input field={@form[:name]} type="text" label="Name" />
              <.input field={@form[:code]} type="text" label="Code" />
              <.input field={@form[:description]} type="textarea" label="Description" />
              <.input field={@form[:active]} type="checkbox" label="Active" />

              <div class="modal-action">
                <.button phx-disable-with="Saving..." variant="primary">Save Organization type</.button>
                <.button type="button" class="btn btn-ghost" phx-click="hide_modal">Cancel</.button>
              </div>
            </.form>
          </div>
          <div class="modal-backdrop" phx-click="hide_modal"></div>
        </div>
      <% end %>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Lookups.subscribe_organization_types(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Organization types")
     |> assign(:show_modal, false)
     |> assign(:modal_title, "")
     |> assign(:form, nil)
     |> assign(:organization_type, nil)
     |> assign(:modal_action, nil)
     |> stream(:organization_types, list_organization_types(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization_type = Lookups.get_organization_type!(socket.assigns.current_scope, id)
    {:ok, _} = Lookups.delete_organization_type(socket.assigns.current_scope, organization_type)

    {:noreply, stream_delete(socket, :organization_types, organization_type)}
  end

  @impl true
  def handle_event("show_modal", %{"action" => "new"}, socket) do
    organization_type = %OrganizationType{user_id: socket.assigns.current_scope.user.id}
    changeset = Lookups.change_organization_type(socket.assigns.current_scope, organization_type)

    {:noreply,
     socket
     |> assign(:show_modal, true)
     |> assign(:modal_title, "New Organization Type")
     |> assign(:modal_action, :new)
     |> assign(:organization_type, organization_type)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("show_modal", %{"action" => "edit", "id" => id}, socket) do
    organization_type = Lookups.get_organization_type!(socket.assigns.current_scope, id)
    changeset = Lookups.change_organization_type(socket.assigns.current_scope, organization_type)

    {:noreply,
     socket
     |> assign(:show_modal, true)
     |> assign(:modal_title, "Edit Organization Type")
     |> assign(:modal_action, :edit)
     |> assign(:organization_type, organization_type)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("hide_modal", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_modal, false)
     |> assign(:form, nil)
     |> assign(:organization_type, nil)
     |> assign(:modal_action, nil)}
  end

  @impl true
  def handle_event("validate", %{"organization_type" => organization_type_params}, socket) do
    changeset =
      Lookups.change_organization_type(
        socket.assigns.current_scope,
        socket.assigns.organization_type,
        organization_type_params
      )
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"organization_type" => organization_type_params}, socket) do
    save_organization_type(socket, socket.assigns.modal_action, organization_type_params)
  end

  @impl true
  def handle_info({type, %Dali.Lookups.OrganizationType{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :organization_types, list_organization_types(socket.assigns.current_scope), reset: true)}
  end

  defp list_organization_types(current_scope) do
    Lookups.list_organization_types(current_scope)
  end

  defp save_organization_type(socket, :edit, organization_type_params) do
    case Lookups.update_organization_type(socket.assigns.current_scope, socket.assigns.organization_type, organization_type_params) do
      {:ok, _organization_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization type updated successfully")
         |> assign(:show_modal, false)
         |> assign(:form, nil)
         |> assign(:organization_type, nil)
         |> assign(:modal_action, nil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_organization_type(socket, :new, organization_type_params) do
    case Lookups.create_organization_type(socket.assigns.current_scope, organization_type_params) do
      {:ok, _organization_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization type created successfully")
         |> assign(:show_modal, false)
         |> assign(:form, nil)
         |> assign(:organization_type, nil)
         |> assign(:modal_action, nil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
