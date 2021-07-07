defmodule Renaissance.World.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Adapters.DynamoDB.DynamoDBSet
  alias RenaissanceText, as: Text

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "rooms" do
    field :description, :string
    field :name, :string
    field :characters, DynamoDBSet, default: []

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
    |> update_change(:description, &Text.unicodify_newlines/1)
  end
end
