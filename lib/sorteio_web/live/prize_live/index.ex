defmodule SorteioWeb.PrizeLive.Index do
  use SorteioWeb, :live_view

  alias Sorteio.Rooms
  alias Sorteio.Rooms.Prize

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :prizes, Rooms.list_prizes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Prize")
    |> assign(:prize, Rooms.get_prize!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Prize")
    |> assign(:prize, %Prize{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Prizes")
    |> assign(:prize, nil)
  end

  @impl true
  def handle_info({SorteioWeb.PrizeLive.FormComponent, {:saved, prize}}, socket) do
    {:noreply, stream_insert(socket, :prizes, prize)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    prize = Rooms.get_prize!(id)
    {:ok, _} = Rooms.delete_prize(prize)

    {:noreply, stream_delete(socket, :prizes, prize)}
  end
end
