defmodule SorteioWeb.RoomLive.Show do
  use SorteioWeb, :live_view
  alias SorteioWeb.PrizeLive.FormComponent

  alias Sorteio.Rooms
  alias SorteioWeb.Presence
  alias Sorteio.Rooms.Prize

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

    form =
      %Prize{}
      |> Rooms.change_prize()
      |> to_form()

    {:ok,
     socket
     |> assign(:admin?, session["admin"] == id)
     |> assign(:id, id)
     |> assign(:users, [])
     |> assign(:prizes, [])
     |> assign(:changeset, form)
     |> reload_users()}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:room, Rooms.get_room!(id))}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, reload_users(socket)}
  end

  @impl true
  def handle_info({FormComponent, {:saved, prize}}, socket) do
    {:noreply, stream_insert(socket, :prizes, prize)}
  end

  @impl true
  def handle_event("create_prize", %{"name" => name}, socket) do
    prize = Rooms.change_prize(%Prize{:name => name, :room_id => socket.assigns.room_id})

    socket
    |> assign(:page_title, "New Prize")
    |> assign(:prize, prize)
  end

  def reload_users(socket) do
    users =
      Presence.list(topic(socket))
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    socket
    |> assign(:users, users)
  end

  def reload_prizes(socket) do
    users =
      Presence.list(topic(socket))
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    socket
    |> assign(:users, users)
  end

  defp page_title(:show), do: "Sala da galera"
  defp page_title(:new), do: "Nova sala"

  defp topic(socket), do: "room:#{socket.assigns.id}"
end
