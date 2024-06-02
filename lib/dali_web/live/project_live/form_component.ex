defmodule DaliWeb.ProjectLive.FormComponent do
  alias Dali.People
  alias Dali.Projects.Teammate
  use DaliWeb, :live_component

  alias Dali.Projects

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:project_number]} type="text" label="Project number" />
        <.input field={@form[:project_name]} type="text" label="Project name" />
        <.input field={@form[:start_date]} type="date" label="Start date" />
        <.input field={@form[:end_date]} type="date" label="End date" />
        <.input field={@form[:status]} type="text" label="Status" />

        <.inputs_for let{teammate} field={@form[:teammates]}>
          <.input type="select" field={teammate[:last_name]} placeholder="Last Name" options={} />
        </.inputs_for>

        <:actions>
          <.button phx-disable-with="Saving...">Save Project</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  s
  @impl true
  def update(%{project: project} = assigns, socket) do
    project_changeset = Projects.change_project(project)

    socket
    |> assign(assigns)
    |> assign_form(project_changeset)
    |> assign_persons()

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Projects.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :edit, project_params) do
    case Projects.update_project(socket.assigns.project, project_params) do
      {:ok, project} ->
        notify_parent({:saved, project})

        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_project(socket, :new, project_params) do
    case Projects.create_project(project_params) do
      {:ok, project} ->
        notify_parent({:saved, project})

        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    if Ecto.Changeset.get_field(changeset, :teammates) == [] do
      teammate = %Teammate{}
      changeset = Ecto.Changeset.put_change(changeset, :teammates, [teammate])
      assign(socket, :form, to_form(changeset))
    else
      assign(socket, :form, to_form(changeset))
    end
  end

  defp assign_persons(socket) do
    persons =
      People.list_persons()
      |> Enum.map(&{&1.last_name, &1.first_name, &1.id})

    assign(socket, :persons, persons)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
