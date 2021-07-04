defmodule Renaissance.World.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "rooms" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
  end
end
