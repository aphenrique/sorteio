defmodule SorteioWeb.UserController do
  use SorteioWeb, :controller

  alias Sorteio.Accounts
  alias Sorteio.Accounts.User

  alias Sorteio.Rooms

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => %{"room_id" => room_id} = user_params}) when room_id not in [""] do
    room = Rooms.get_room!(room_id)

    conn
    |> put_session("name", user_params["name"])
    |> put_session("email", user_params["email"])
    |> delete_session("admin")
    |> redirect(to: ~p"/rooms/#{room.id}")
  end

  def create(conn, %{"user" => user_params}) do
    {:ok, room} = Rooms.create_room(%{})

    conn
    |> put_session("name", user_params["name"])
    |> put_session("email", user_params["email"])
    |> put_session("admin", room.id)
    |> put_flash(:info, "Room created successfully")
    |> redirect(to: ~p"/rooms/#{room.id}")
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: ~p"/users/new")
  end
end
