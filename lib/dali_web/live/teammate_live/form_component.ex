defmodule DaliWeb.TeammateLive.FormComponent do
  use DaliWeb, :live_component

  alias Dali.Projects

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage teammate records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="teammate-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:project_id]} type="number" label="Project" />
        <.input field={@form[:person_id]} type="number" label="Person" />
        <.input field={@form[:discipline_id]} type="number" label="Discipline" />
        <.input field={@form[:role_id]} type="number" label="Role" />
        <.input field={@form[:role_type]} type="text" label="Role type" />
        <.input field={@form[:responsibilties]} type="text" label="Responsibilties" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Teammate</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{teammate: teammate} = assigns, socket) do
    changeset = Projects.change_teammate(teammate)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"teammate" => teammate_params}, socket) do
    changeset =
      socket.assigns.teammate
      |> Projects.change_teammate(teammate_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"teammate" => teammate_params}, socket) do
    save_teammate(socket, socket.assigns.action, teammate_params)
  end

  defp save_teammate(socket, :edit, teammate_params) do
    case Projects.update_teammate(socket.assigns.teammate, teammate_params) do
      {:ok, teammate} ->
        notify_parent({:saved, teammate})

        {:noreply,
         socket
         |> put_flash(:info, "Teammate updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_teammate(socket, :new, teammate_params) do
    case Projects.create_teammate(teammate_params) do
      {:ok, teammate} ->
        notify_parent({:saved, teammate})

        {:noreply,
         socket
         |> put_flash(:info, "Teammate created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
