defmodule DaliWeb.TeammateLive.Index do
  use DaliWeb, :live_view

  alias Dali.Projects
  alias Dali.Projects.Teammate

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :teammates, Projects.list_teammates())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Teammate")
    |> assign(:teammate, Projects.get_teammate!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Teammate")
    |> assign(:teammate, %Teammate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teammates")
    |> assign(:teammate, nil)
  end

  @impl true
  def handle_info({DaliWeb.TeammateLive.FormComponent, {:saved, teammate}}, socket) do
    {:noreply, stream_insert(socket, :teammates, teammate)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    teammate = Projects.get_teammate!(id)
    {:ok, _} = Projects.delete_teammate(teammate)

    {:noreply, stream_delete(socket, :teammates, teammate)}
  end
end
