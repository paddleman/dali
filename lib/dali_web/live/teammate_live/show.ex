defmodule DaliWeb.TeammateLive.Show do
  use DaliWeb, :live_view

  alias Dali.Projects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:teammate, Projects.get_teammate!(id))}
  end

  defp page_title(:show), do: "Show Teammate"
  defp page_title(:edit), do: "Edit Teammate"
end
