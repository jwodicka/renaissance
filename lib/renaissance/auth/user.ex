defmodule Renaissance.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :authid, :string
    field :name, :string
    field :sysadmin, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:authid, :name, :sysadmin])
    |> validate_required([:authid, :name])
  end
end
