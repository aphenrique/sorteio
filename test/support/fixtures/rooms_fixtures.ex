defmodule Sorteio.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sorteio.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{

      })
      |> Sorteio.Rooms.create_room()

    room
  end

  @doc """
  Generate a prize.
  """
  def prize_fixture(attrs \\ %{}) do
    {:ok, prize} =
      attrs
      |> Enum.into(%{
        name: "some name",
        winner_email: "some winner_email",
        winner_name: "some winner_name"
      })
      |> Sorteio.Rooms.create_prize()

    prize
  end
end
