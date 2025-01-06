defmodule SorteioWeb.PrizeLiveTest do
  use SorteioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sorteio.RoomsFixtures

  @create_attrs %{name: "some name", winner_name: "some winner_name", winner_email: "some winner_email"}
  @update_attrs %{name: "some updated name", winner_name: "some updated winner_name", winner_email: "some updated winner_email"}
  @invalid_attrs %{name: nil, winner_name: nil, winner_email: nil}

  defp create_prize(_) do
    prize = prize_fixture()
    %{prize: prize}
  end

  describe "Index" do
    setup [:create_prize]

    test "lists all prizes", %{conn: conn, prize: prize} do
      {:ok, _index_live, html} = live(conn, ~p"/prizes")

      assert html =~ "Listing Prizes"
      assert html =~ prize.name
    end

    test "saves new prize", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/prizes")

      assert index_live |> element("a", "New Prize") |> render_click() =~
               "New Prize"

      assert_patch(index_live, ~p"/prizes/new")

      assert index_live
             |> form("#prize-form", prize: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#prize-form", prize: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/prizes")

      html = render(index_live)
      assert html =~ "Prize created successfully"
      assert html =~ "some name"
    end

    test "updates prize in listing", %{conn: conn, prize: prize} do
      {:ok, index_live, _html} = live(conn, ~p"/prizes")

      assert index_live |> element("#prizes-#{prize.id} a", "Edit") |> render_click() =~
               "Edit Prize"

      assert_patch(index_live, ~p"/prizes/#{prize}/edit")

      assert index_live
             |> form("#prize-form", prize: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#prize-form", prize: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/prizes")

      html = render(index_live)
      assert html =~ "Prize updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes prize in listing", %{conn: conn, prize: prize} do
      {:ok, index_live, _html} = live(conn, ~p"/prizes")

      assert index_live |> element("#prizes-#{prize.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#prizes-#{prize.id}")
    end
  end

  describe "Show" do
    setup [:create_prize]

    test "displays prize", %{conn: conn, prize: prize} do
      {:ok, _show_live, html} = live(conn, ~p"/prizes/#{prize}")

      assert html =~ "Show Prize"
      assert html =~ prize.name
    end

    test "updates prize within modal", %{conn: conn, prize: prize} do
      {:ok, show_live, _html} = live(conn, ~p"/prizes/#{prize}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Prize"

      assert_patch(show_live, ~p"/prizes/#{prize}/show/edit")

      assert show_live
             |> form("#prize-form", prize: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#prize-form", prize: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/prizes/#{prize}")

      html = render(show_live)
      assert html =~ "Prize updated successfully"
      assert html =~ "some updated name"
    end
  end
end
