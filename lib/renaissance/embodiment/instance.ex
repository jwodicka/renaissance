defmodule Renaissance.Embodiment.Instance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "embodiment_instances" do
    # TODO: Can we use characterid as the hash key on its own, and just index on userid?
    # HASH KEY compound userid|characterid
    field :id, :string, primary_key: true
    # RANGE KEY
    field :instance_id, :string, default: "default", primary_key: true
    field :userid, :string
    field :characterid, :string
    field :roomid, :string

    timestamps()
  end

  defp compute_id(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{userid: uid, characterid: cid, id: ucid}} ->
        if ucid == "#{uid}|#{cid}" do
          changeset
        else
          add_error(changeset, :id, "Provided an id that doesn't match the user and character.")
        end

      %Ecto.Changeset{changes: %{userid: uid, characterid: cid}} ->
        put_change(changeset, :id, "#{uid}|#{cid}")

      _ ->
        changeset
    end
  end

  @doc false
  def changeset(instance, attrs) do
    instance
    |> cast(attrs, [:id, :instance_id, :userid, :characterid, :roomid])
    |> compute_id()
    |> validate_required([:id, :userid, :characterid, :roomid])
    # This is actually validating {id, instance_id}, but Ecto and Dynamo don't speak the same language.
    |> unique_constraint(:id)
  end
end
