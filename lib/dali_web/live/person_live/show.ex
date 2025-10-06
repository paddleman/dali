defmodule DaliWeb.PersonLive.Show do
  use DaliWeb, :live_view

  alias Dali.People

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Person {@person.id}
        <:subtitle>This is a person record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/persons"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/persons/#{@person}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit person
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="First name">{@person.first_name}</:item>
        <:item title="Last name">{@person.last_name}</:item>
      </.list>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      People.subscribe_persons(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Person")
     |> assign(:person, People.get_person!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Dali.People.Person{id: id} = person},
        %{assigns: %{person: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :person, person)}
  end

  def handle_info(
        {:deleted, %Dali.People.Person{id: id}},
        %{assigns: %{person: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current person was deleted.")
     |> push_navigate(to: ~p"/persons")}
  end

  def handle_info({type, %Dali.People.Person{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
