defmodule DaliWeb.TaskTypeLive.Index do
  use DaliWeb, :live_view

  alias Dali.Lookups
  alias Dali.Lookups.TaskType

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Task types
        <:actions>
          <.button variant="primary" phx-click="show_modal" phx-value-action="new">
            <.icon name="hero-plus" /> New Task type
          </.button>
        </:actions>
      </.header>

      <.table
        id="task_types"
        rows={@streams.task_types}
        row_click={fn {_id, task_type} -> JS.navigate(~p"/task_types/#{task_type}") end}
      >
        <:col :let={{_id, task_type}} label="Name">{task_type.name}</:col>
        <:col :let={{_id, task_type}} label="Code">{task_type.code}</:col>
        <:col :let={{_id, task_type}} label="Description">{task_type.description}</:col>
        <:col :let={{_id, task_type}} label="Active">{task_type.active}</:col>
        <:action :let={{_id, task_type}}>
          <div class="sr-only">
            <.link navigate={~p"/task_types/#{task_type}"}>Show</.link>
          </div>
          <.button phx-click="show_modal" phx-value-action="edit" phx-value-id={task_type.id}>
            Edit
          </.button>
        </:action>
        <:action :let={{id, task_type}}>
          <.link
            phx-click={JS.push("delete", value: %{id: task_type.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>

      <!-- DaisyUI Modal for Form -->
      <%= if @show_modal do %>
        <div class="modal modal-open">
          <div class="modal-box">
            <h3 class="font-bold text-lg">{@modal_title}</h3>

            <.form :if={@form} for={@form} id="task_type-modal-form" phx-change="validate" phx-submit="save">
              <.input field={@form[:name]} type="text" label="Name" />
              <.input field={@form[:code]} type="text" label="Code" />
              <.input field={@form[:description]} type="textarea" label="Description" />
              <.input field={@form[:active]} type="checkbox" label="Active" />

              <div class="modal-action">
                <.button phx-disable-with="Saving..." variant="primary">Save Task type</.button>
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
      Lookups.subscribe_task_types(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Task types")
     |> assign(:show_modal, false)
     |> assign(:modal_title, "")
     |> assign(:form, nil)
     |> assign(:task_type, nil)
     |> assign(:modal_action, nil)
     |> stream(:task_types, list_task_types(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task_type = Lookups.get_task_type!(socket.assigns.current_scope, id)
    {:ok, _} = Lookups.delete_task_type(socket.assigns.current_scope, task_type)

    {:noreply, stream_delete(socket, :task_types, task_type)}
  end

  @impl true
  def handle_event("show_modal", %{"action" => "new"}, socket) do
    task_type = %TaskType{user_id: socket.assigns.current_scope.user.id}
    changeset = Lookups.change_task_type(socket.assigns.current_scope, task_type)

    {:noreply,
     socket
     |> assign(:show_modal, true)
     |> assign(:modal_title, "New Task Type")
     |> assign(:modal_action, :new)
     |> assign(:task_type, task_type)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("show_modal", %{"action" => "edit", "id" => id}, socket) do
    task_type = Lookups.get_task_type!(socket.assigns.current_scope, id)
    changeset = Lookups.change_task_type(socket.assigns.current_scope, task_type)

    {:noreply,
     socket
     |> assign(:show_modal, true)
     |> assign(:modal_title, "Edit Task Type")
     |> assign(:modal_action, :edit)
     |> assign(:task_type, task_type)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("hide_modal", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_modal, false)
     |> assign(:form, nil)
     |> assign(:task_type, nil)
     |> assign(:modal_action, nil)}
  end

  @impl true
  def handle_event("validate", %{"task_type" => task_type_params}, socket) do
    changeset =
      Lookups.change_task_type(
        socket.assigns.current_scope,
        socket.assigns.task_type,
        task_type_params
      )
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"task_type" => task_type_params}, socket) do
    save_task_type(socket, socket.assigns.modal_action, task_type_params)
  end

  @impl true
  def handle_info({type, %Dali.Lookups.TaskType{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :task_types, list_task_types(socket.assigns.current_scope), reset: true)}
  end

  defp list_task_types(current_scope) do
    Lookups.list_task_types(current_scope)
  end

  defp save_task_type(socket, :edit, task_type_params) do
    case Lookups.update_task_type(socket.assigns.current_scope, socket.assigns.task_type, task_type_params) do
      {:ok, _task_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task type updated successfully")
         |> assign(:show_modal, false)
         |> assign(:form, nil)
         |> assign(:task_type, nil)
         |> assign(:modal_action, nil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task_type(socket, :new, task_type_params) do
    case Lookups.create_task_type(socket.assigns.current_scope, task_type_params) do
      {:ok, _task_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task type created successfully")
         |> assign(:show_modal, false)
         |> assign(:form, nil)
         |> assign(:task_type, nil)
         |> assign(:modal_action, nil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
