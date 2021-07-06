defmodule Renaissance.Transcript.Message do
  use Ecto.Schema
  import Ecto.Changeset

  # TODO: Messages should be immutable - edits create new messages.

  @primary_key {:channelid, :string, autogenerate: false}
  @foreign_key_type :binary_id
  schema "messages" do
    field :timestamp, :integer # Range key

    field :characterid, :string
    field :userid, :string

    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:channelid, :timestamp, :characterid, :userid, :content])
    |> validate_required([:channelid, :timestamp, :characterid, :userid, :content])
  end
end

defimpl Phoenix.HTML.Safe, for: Renaissance.Transcript.Message do
  def to_iodata(message) do
    message.content # TODO: THIS IS NOT SAFE. WE ARE NOT DOING ANYTHING TO MAKE IT SAFE.
  end
end
