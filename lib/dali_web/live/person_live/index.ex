defmodule DaliWeb.PersonLive.Index do
  use DaliWeb, :live_view

  alias Dali.People

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Persons
        <:actions>
          <.button variant="primary" navigate={~p"/persons/new"}>
            <.icon name="hero-plus" /> New Person
          </.button>
        </:actions>
      </.header>

      <.table
        id="persons"
        rows={@streams.persons}
        row_click={fn {_id, person} -> JS.navigate(~p"/persons/#{person}") end}
      >
        <:col :let={{_id, person}} label="First name">{person.first_name}</:col>
        <:col :let={{_id, person}} label="Last name">{person.last_name}</:col>
        <:action :let={{_id, person}}>
          <div class="sr-only">
            <.link navigate={~p"/persons/#{person}"}>Show</.link>
          </div>
          <.link navigate={~p"/persons/#{person}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, person}}>
          <.link
            phx-click={JS.push("delete", value: %{id: person.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.main_app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      People.subscribe_persons(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Persons")
     |> stream(:persons, list_persons(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = People.get_person!(socket.assigns.current_scope, id)
    {:ok, _} = People.delete_person(socket.assigns.current_scope, person)

    {:noreply, stream_delete(socket, :persons, person)}
  end

  @impl true
  def handle_info({type, %Dali.People.Person{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :persons, list_persons(socket.assigns.current_scope), reset: true)}
  end

  defp list_persons(current_scope) do
    People.list_persons(current_scope)
  end
end
