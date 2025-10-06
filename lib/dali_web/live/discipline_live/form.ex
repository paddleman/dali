defmodule DaliWeb.DisciplineLive.Form do
  use DaliWeb, :live_view

  alias Dali.Lookups
  alias Dali.Lookups.Discipline

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage discipline records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="discipline-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:code]} type="text" label="Code" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Discipline</.button>
          <.button navigate={return_path(@current_scope, @return_to, @discipline)}>Cancel</.button>
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
    discipline = Lookups.get_discipline!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Discipline")
    |> assign(:discipline, discipline)
    |> assign(:form, to_form(Lookups.change_discipline(socket.assigns.current_scope, discipline)))
  end

  defp apply_action(socket, :new, _params) do
    discipline = %Discipline{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Discipline")
    |> assign(:discipline, discipline)
    |> assign(:form, to_form(Lookups.change_discipline(socket.assigns.current_scope, discipline)))
  end

  @impl true
  def handle_event("validate", %{"discipline" => discipline_params}, socket) do
    changeset = Lookups.change_discipline(socket.assigns.current_scope, socket.assigns.discipline, discipline_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"discipline" => discipline_params}, socket) do
    save_discipline(socket, socket.assigns.live_action, discipline_params)
  end

  defp save_discipline(socket, :edit, discipline_params) do
    case Lookups.update_discipline(socket.assigns.current_scope, socket.assigns.discipline, discipline_params) do
      {:ok, discipline} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discipline updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, discipline)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_discipline(socket, :new, discipline_params) do
    case Lookups.create_discipline(socket.assigns.current_scope, discipline_params) do
      {:ok, discipline} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discipline created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, discipline)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _discipline), do: ~p"/disciplines"
  defp return_path(_scope, "show", discipline), do: ~p"/disciplines/#{discipline}"
end
