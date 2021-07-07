defmodule Renaissance.World.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Adapters.DynamoDB.DynamoDBSet

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "rooms" do
    field :description, :string
    field :name, :string
    field :characters, DynamoDBSet, default: []

    timestamps()
  end

  @spec unicodify_newlines(binary) :: binary
  def unicodify_newlines(str) do
    Regex.replace(~r/[\r\n]+/, str, "\u2029")
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
    |> update_change(:description, &unicodify_newlines/1)
  end
end
