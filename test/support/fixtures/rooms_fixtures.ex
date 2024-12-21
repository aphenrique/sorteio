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
end
