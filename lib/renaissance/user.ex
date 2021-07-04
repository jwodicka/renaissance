defmodule Renaissance.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:authid, :string, autogenerate: false}
  schema "users" do
    # field :authid, :string
    field :name, :string
    field :sysadmin, :boolean, default: false

    timestamps()
  end

  @spec find_or_create(String.t, String.t) :: {:ok, User} | {:error, term}
  def find_or_create(authid, name) do
    case find_by_authid(authid) do
      nil -> create(%{authid: authid, name: name})
      user -> {:ok, user}
    end
  end

  def create(attrs) do
    %Renaissance.User{}
    |> changeset(attrs)
    |> Renaissance.Repo.insert()
  end

  @spec find_by_authid(any) :: any
  def find_by_authid(authid) do
    IO.puts(authid)
    Renaissance.Repo.get(Renaissance.User, authid)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:authid, :name, :sysadmin])
    |> validate_required([:authid, :name])
  end
end
