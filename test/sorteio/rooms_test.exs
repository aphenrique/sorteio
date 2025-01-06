defmodule Sorteio.RoomsTest do
  use Sorteio.DataCase

  alias Sorteio.Rooms

  describe "rooms" do
    alias Sorteio.Rooms.Room

    import Sorteio.RoomsFixtures

    @invalid_attrs %{}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{}

      assert {:ok, %Room{} = room} = Rooms.create_room(valid_attrs)
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{}

      assert {:ok, %Room{} = room} = Rooms.update_room(room, update_attrs)
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end

  describe "prizes" do
    alias Sorteio.Rooms.Prize

    import Sorteio.RoomsFixtures

    @invalid_attrs %{name: nil, winner_name: nil, winner_email: nil}

    test "list_prizes/0 returns all prizes" do
      prize = prize_fixture()
      assert Rooms.list_prizes() == [prize]
    end

    test "get_prize!/1 returns the prize with given id" do
      prize = prize_fixture()
      assert Rooms.get_prize!(prize.id) == prize
    end

    test "create_prize/1 with valid data creates a prize" do
      valid_attrs = %{name: "some name", winner_name: "some winner_name", winner_email: "some winner_email"}

      assert {:ok, %Prize{} = prize} = Rooms.create_prize(valid_attrs)
      assert prize.name == "some name"
      assert prize.winner_name == "some winner_name"
      assert prize.winner_email == "some winner_email"
    end

    test "create_prize/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_prize(@invalid_attrs)
    end

    test "update_prize/2 with valid data updates the prize" do
      prize = prize_fixture()
      update_attrs = %{name: "some updated name", winner_name: "some updated winner_name", winner_email: "some updated winner_email"}

      assert {:ok, %Prize{} = prize} = Rooms.update_prize(prize, update_attrs)
      assert prize.name == "some updated name"
      assert prize.winner_name == "some updated winner_name"
      assert prize.winner_email == "some updated winner_email"
    end

    test "update_prize/2 with invalid data returns error changeset" do
      prize = prize_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_prize(prize, @invalid_attrs)
      assert prize == Rooms.get_prize!(prize.id)
    end

    test "delete_prize/1 deletes the prize" do
      prize = prize_fixture()
      assert {:ok, %Prize{}} = Rooms.delete_prize(prize)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_prize!(prize.id) end
    end

    test "change_prize/1 returns a prize changeset" do
      prize = prize_fixture()
      assert %Ecto.Changeset{} = Rooms.change_prize(prize)
    end
  end
end
