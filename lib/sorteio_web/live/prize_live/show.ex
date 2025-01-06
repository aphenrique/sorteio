defmodule SorteioWeb.PrizeLive.Show do
  use SorteioWeb, :live_view

  alias Sorteio.Rooms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:prize, Rooms.get_prize!(id))}
  end

  defp page_title(:show), do: "Show Prize"
  defp page_title(:edit), do: "Edit Prize"
end
