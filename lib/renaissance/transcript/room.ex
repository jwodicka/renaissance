defmodule Renaissance.Transcript.Room do
  use Ecto.Schema
  import Ecto.Changeset

  # TODO: Is this even needed? We might be able to just use the channel id and not
  #       bother with having transcript have a notion of rooms as independent from channels.

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :messages, {:array, :string}, default: []

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:messages])
    |> validate_required([:messages])
  end
end
