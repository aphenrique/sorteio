defmodule SorteioWeb.RoomLive.Show do
  use SorteioWeb, :live_view

  alias Sorteio.Rooms
  alias SorteioWeb.Presence

  @impl true
  def mount(%{"id" => id}, session, socket) do
    topic = "room:#{id}"

    Presence.track(
      self(),
      topic,
      session["email"],
      %{
        name: session["name"],
        user_id: session["email"]
      }
    )

    SorteioWeb.Endpoint.subscribe(topic)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:room, Rooms.get_room!(id))}
  end

  @impl true
  def handle_info(%{event: "presence_diff"} = event, socket) do
    event
    |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Room"
  defp page_title(:edit), do: "Edit Room"
end
