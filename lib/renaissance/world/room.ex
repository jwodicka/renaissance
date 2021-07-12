defmodule Renaissance.World.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias RenaissanceText, as: Text

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "rooms" do
    field :name, :string
    field :description, :string
    field :exits, {:map, :string}, default: %{}

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:description, :name, :exits])
    |> validate_required([:description, :name])
    |> update_change(:description, &Text.unicodify_newlines/1)
  end
end
