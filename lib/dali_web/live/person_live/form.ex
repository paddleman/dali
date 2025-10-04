defmodule DaliWeb.PersonLive.Form do
  use DaliWeb, :live_view

  alias Dali.People
  alias Dali.People.Person

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="person-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:first_name]} type="text" label="First name" />
        <.input field={@form[:last_name]} type="text" label="Last name" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Person</.button>
          <.button navigate={return_path(@current_scope, @return_to, @person)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    person = People.get_person!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, person)
    |> assign(:form, to_form(People.change_person(socket.assigns.current_scope, person)))
  end

  defp apply_action(socket, :new, _params) do
    person = %Person{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, person)
    |> assign(:form, to_form(People.change_person(socket.assigns.current_scope, person)))
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset = People.change_person(socket.assigns.current_scope, socket.assigns.person, person_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.live_action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    case People.update_person(socket.assigns.current_scope, socket.assigns.person, person_params) do
      {:ok, person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, person)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_person(socket, :new, person_params) do
    case People.create_person(socket.assigns.current_scope, person_params) do
      {:ok, person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, person)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _person), do: ~p"/persons"
  defp return_path(_scope, "show", person), do: ~p"/persons/#{person}"
end
