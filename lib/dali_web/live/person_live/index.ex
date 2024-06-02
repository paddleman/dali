defmodule DaliWeb.PersonLive.Index do
  use DaliWeb, :live_view

  alias Dali.People
  alias Dali.People.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :persons, People.list_persons())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, People.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Persons")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({DaliWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    {:noreply, stream_insert(socket, :persons, person)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = People.get_person!(id)
    {:ok, _} = People.delete_person(person)

    {:noreply, stream_delete(socket, :persons, person)}
  end
end
