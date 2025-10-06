defmodule DaliWeb.OrganizationTypeLive.Form do
  use DaliWeb, :live_view

  alias Dali.Lookups
  alias Dali.Lookups.OrganizationType

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage organization_type records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="organization_type-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:code]} type="text" label="Code" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Organization type</.button>
          <.button navigate={return_path(@current_scope, @return_to, @organization_type)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    organization_type = Lookups.get_organization_type!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Organization type")
    |> assign(:organization_type, organization_type)
    |> assign(:form, to_form(Lookups.change_organization_type(socket.assigns.current_scope, organization_type)))
  end

  defp apply_action(socket, :new, _params) do
    organization_type = %OrganizationType{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Organization type")
    |> assign(:organization_type, organization_type)
    |> assign(:form, to_form(Lookups.change_organization_type(socket.assigns.current_scope, organization_type)))
  end

  @impl true
  def handle_event("validate", %{"organization_type" => organization_type_params}, socket) do
    changeset = Lookups.change_organization_type(socket.assigns.current_scope, socket.assigns.organization_type, organization_type_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"organization_type" => organization_type_params}, socket) do
    save_organization_type(socket, socket.assigns.live_action, organization_type_params)
  end

  defp save_organization_type(socket, :edit, organization_type_params) do
    case Lookups.update_organization_type(socket.assigns.current_scope, socket.assigns.organization_type, organization_type_params) do
      {:ok, organization_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization type updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, organization_type)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_organization_type(socket, :new, organization_type_params) do
    case Lookups.create_organization_type(socket.assigns.current_scope, organization_type_params) do
      {:ok, organization_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization type created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, organization_type)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _organization_type), do: ~p"/organization_types"
  defp return_path(_scope, "show", organization_type), do: ~p"/organization_types/#{organization_type}"
end
