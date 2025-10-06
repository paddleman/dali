defmodule DaliWeb.DisciplineLive.Show do
  use DaliWeb, :live_view

  alias Dali.Lookups

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Discipline {@discipline.id}
        <:subtitle>This is a discipline record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/disciplines"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/disciplines/#{@discipline}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit discipline
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@discipline.name}</:item>
        <:item title="Code">{@discipline.code}</:item>
        <:item title="Description">{@discipline.description}</:item>
        <:item title="Active">{@discipline.active}</:item>
      </.list>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Lookups.subscribe_disciplines(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Discipline")
     |> assign(:discipline, Lookups.get_discipline!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Dali.Lookups.Discipline{id: id} = discipline},
        %{assigns: %{discipline: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :discipline, discipline)}
  end

  def handle_info(
        {:deleted, %Dali.Lookups.Discipline{id: id}},
        %{assigns: %{discipline: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current discipline was deleted.")
     |> push_navigate(to: ~p"/disciplines")}
  end

  def handle_info({type, %Dali.Lookups.Discipline{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
