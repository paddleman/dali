defmodule DaliWeb.DisciplineLive.Index do
  use DaliWeb, :live_view

  alias Dali.Lookups
  alias Dali.Lookups.Discipline

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.main_app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Disciplines
        <:actions>
          <.button variant="primary" phx-click="show_modal" phx-value-action="new">
            <.icon name="hero-plus" /> New Discipline
          </.button>
        </:actions>
      </.header>

      <.table
        id="disciplines"
        rows={@streams.disciplines}
        row_click={fn {_id, discipline} -> JS.navigate(~p"/disciplines/#{discipline}") end}
      >
        <:col :let={{_id, discipline}} label="Name">{discipline.name}</:col>
        <:col :let={{_id, discipline}} label="Code">{discipline.code}</:col>
        <:col :let={{_id, discipline}} label="Description">{discipline.description}</:col>
        <:col :let={{_id, discipline}} label="Active">{discipline.active}</:col>
        <:action :let={{_id, discipline}}>
          <div class="sr-only">
            <.link navigate={~p"/disciplines/#{discipline}"}>Show</.link>
          </div>
          <.button phx-click="show_modal" phx-value-action="edit" phx-value-id={discipline.id}>
            Edit
          </.button>
        </:action>
        <:action :let={{id, discipline}}>
          <.link
            phx-click={JS.push("delete", value: %{id: discipline.id}) |> hide("##{id}")}
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

            <.form :if={@form} for={@form} id="discipline-modal-form" phx-change="validate" phx-submit="save">
              <.input field={@form[:name]} type="text" label="Name" />
              <.input field={@form[:code]} type="text" label="Code" />
              <.input field={@form[:description]} type="textarea" label="Description" />
              <.input field={@form[:active]} type="checkbox" label="Active" />

              <div class="modal-action">
                <.button phx-disable-with="Saving..." variant="primary">Save Discipline</.button>
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
      Lookups.subscribe_disciplines(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Disciplines")
     |> assign(:show_modal, false)
     |> assign(:modal_title, "")
     |> assign(:form, nil)
     |> assign(:discipline, nil)
     |> assign(:modal_action, nil)
     |> stream(:disciplines, list_disciplines(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    discipline = Lookups.get_discipline!(socket.assigns.current_scope, id)
    {:ok, _} = Lookups.delete_discipline(socket.assigns.current_scope, discipline)

    {:noreply, stream_delete(socket, :disciplines, discipline)}
  end

  @impl true
  def handle_event("show_modal", %{"action" => "new"}, socket) do
    discipline = %Discipline{user_id: socket.assigns.current_scope.user.id}
    changeset = Lookups.change_discipline(socket.assigns.current_scope, discipline)

    {:noreply,
     socket
     |> assign(:show_modal, true)
     |> assign(:modal_title, "New Discipline")
     |> assign(:modal_action, :new)
     |> assign(:discipline, discipline)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("show_modal", %{"action" => "edit", "id" => id}, socket) do
    discipline = Lookups.get_discipline!(socket.assigns.current_scope, id)
    changeset = Lookups.change_discipline(socket.assigns.current_scope, discipline)

    {:noreply,
     socket
     |> assign(:show_modal, true)
     |> assign(:modal_title, "Edit Discipline")
     |> assign(:modal_action, :edit)
     |> assign(:discipline, discipline)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("hide_modal", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_modal, false)
     |> assign(:form, nil)
     |> assign(:discipline, nil)
     |> assign(:modal_action, nil)}
  end

  @impl true
  def handle_event("validate", %{"discipline" => discipline_params}, socket) do
    changeset =
      Lookups.change_discipline(
        socket.assigns.current_scope,
        socket.assigns.discipline,
        discipline_params
      )
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"discipline" => discipline_params}, socket) do
    save_discipline(socket, socket.assigns.modal_action, discipline_params)
  end

  @impl true
  def handle_info({type, %Dali.Lookups.Discipline{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :disciplines, list_disciplines(socket.assigns.current_scope), reset: true)}
  end

  defp list_disciplines(current_scope) do
    Lookups.list_disciplines(current_scope)
  end

  defp save_discipline(socket, :edit, discipline_params) do
    case Lookups.update_discipline(socket.assigns.current_scope, socket.assigns.discipline, discipline_params) do
      {:ok, _discipline} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discipline updated successfully")
         |> assign(:show_modal, false)
         |> assign(:form, nil)
         |> assign(:discipline, nil)
         |> assign(:modal_action, nil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_discipline(socket, :new, discipline_params) do
    case Lookups.create_discipline(socket.assigns.current_scope, discipline_params) do
      {:ok, _discipline} ->
        {:noreply,
         socket
         |> put_flash(:info, "Discipline created successfully")
         |> assign(:show_modal, false)
         |> assign(:form, nil)
         |> assign(:discipline, nil)
         |> assign(:modal_action, nil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
