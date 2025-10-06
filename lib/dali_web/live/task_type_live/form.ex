defmodule DaliWeb.TaskTypeLive.Form do
  use DaliWeb, :live_view

  alias Dali.Lookups
  alias Dali.Lookups.TaskType

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage task_type records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="task_type-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:code]} type="text" label="Code" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Task type</.button>
          <.button navigate={return_path(@current_scope, @return_to, @task_type)}>Cancel</.button>
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
    task_type = Lookups.get_task_type!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Task type")
    |> assign(:task_type, task_type)
    |> assign(:form, to_form(Lookups.change_task_type(socket.assigns.current_scope, task_type)))
  end

  defp apply_action(socket, :new, _params) do
    task_type = %TaskType{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Task type")
    |> assign(:task_type, task_type)
    |> assign(:form, to_form(Lookups.change_task_type(socket.assigns.current_scope, task_type)))
  end

  @impl true
  def handle_event("validate", %{"task_type" => task_type_params}, socket) do
    changeset = Lookups.change_task_type(socket.assigns.current_scope, socket.assigns.task_type, task_type_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"task_type" => task_type_params}, socket) do
    save_task_type(socket, socket.assigns.live_action, task_type_params)
  end

  defp save_task_type(socket, :edit, task_type_params) do
    case Lookups.update_task_type(socket.assigns.current_scope, socket.assigns.task_type, task_type_params) do
      {:ok, task_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task type updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, task_type)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task_type(socket, :new, task_type_params) do
    case Lookups.create_task_type(socket.assigns.current_scope, task_type_params) do
      {:ok, task_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task type created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, task_type)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _task_type), do: ~p"/task_types"
  defp return_path(_scope, "show", task_type), do: ~p"/task_types/#{task_type}"
end
