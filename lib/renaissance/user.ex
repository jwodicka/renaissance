defmodule Renaissance.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :authid, :string
    field :name, :string
    field :sysadmin, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :name, :sysadmin])
    |> validate_required([:id, :name, :sysadmin])
  end
end
