defmodule Sorteio.Rooms.Prize do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "prizes" do
    field :name, :string
    field :winner_name, :string
    field :winner_email, :string
    field :room_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prize, attrs) do
    prize
    |> cast(attrs, [:name, :winner_name, :winner_email])
    |> validate_required([:name])
  end
end
