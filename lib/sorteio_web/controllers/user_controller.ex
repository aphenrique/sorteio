defmodule SorteioWeb.UserController do
  use SorteioWeb, :controller

  alias Sorteio.Accounts
  alias Sorteio.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user}) do
    conn
    |> put_session("name", user["name"])
    |> put_session("email", user["email"])
    |> redirect(to: ~p"/")
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: ~p"/users/new")
  end
end
