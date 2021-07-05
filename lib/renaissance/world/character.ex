defmodule Renaissance.World.Character do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "characters" do
    field :admin, :string # admin should be the id of a user
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :description, :admin])
    |> validate_required([:name, :admin])
    # TODO: Validate that admin is actually a valid user ID
  end
end
