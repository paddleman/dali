defmodule DaliWeb.TaskTypeLive.Show do
  use DaliWeb, :live_view

  alias Dali.Lookups

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Task type {@task_type.id}
        <:subtitle>This is a task_type record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/task_types"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/task_types/#{@task_type}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit task_type
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@task_type.name}</:item>
        <:item title="Code">{@task_type.code}</:item>
        <:item title="Description">{@task_type.description}</:item>
        <:item title="Active">{@task_type.active}</:item>
      </.list>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Lookups.subscribe_task_types(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Task type")
     |> assign(:task_type, Lookups.get_task_type!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Dali.Lookups.TaskType{id: id} = task_type},
        %{assigns: %{task_type: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :task_type, task_type)}
  end

  def handle_info(
        {:deleted, %Dali.Lookups.TaskType{id: id}},
        %{assigns: %{task_type: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current task_type was deleted.")
     |> push_navigate(to: ~p"/task_types")}
  end

  def handle_info({type, %Dali.Lookups.TaskType{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
