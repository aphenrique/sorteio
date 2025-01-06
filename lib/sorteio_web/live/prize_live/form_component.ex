defmodule SorteioWeb.PrizeLive.FormComponent do
  use SorteioWeb, :live_component

  alias Sorteio.Rooms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@changeset}
        id="prize-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save_prize"
      >
        <.input field={@changeset[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Prize</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{prize: prize} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Rooms.change_prize(prize))
     end)}
  end

  @impl true
  def handle_event("validate", %{"prize" => prize_params}, socket) do
    changeset = Rooms.change_prize(socket.assigns.prize, prize_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"prize" => prize_params}, socket) do
    save_prize(socket, socket.assigns.action, prize_params)
  end

  defp save_prize(socket, :edit, prize_params) do
    case Rooms.update_prize(socket.assigns.prize, prize_params) do
      {:ok, prize} ->
        notify_parent({:saved, prize})

        {:noreply,
         socket
         |> put_flash(:info, "Prize updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_prize(socket, :new, prize_params) do
    case Rooms.create_prize(prize_params) do
      {:ok, prize} ->
        notify_parent({:saved, prize})

        {:noreply,
         socket
         |> put_flash(:info, "Prize created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
