defmodule Renaissance.Embodiment do
  @moduledoc """
  The Embodiment context.
  """

  import Ecto.Query, warn: false
  alias Renaissance.Repo

  alias Renaissance.Embodiment.Instance

  @doc """
  Returns the list of embodiment_instances.

  ## Examples

      iex> list_embodiment_instances()
      [%Instance{}, ...]

  """
  def list_embodiment_instances do
    Repo.all(Instance, scan: true)
  end

  @doc """
  Gets a single instance.

  Raises `Ecto.NoResultsError` if the Instance does not exist.

  ## Examples

      iex> get_instance!(123)
      %Instance{}

      iex> get_instance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_instance!(id, iid \\ "default"), do: Repo.get_by!(Instance, id: id, instance_id: iid)

  @doc """
  Creates a instance.

  ## Examples

      iex> create_instance(%{field: value})
      {:ok, %Instance{}}

      iex> create_instance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_instance(attrs \\ %{}) do
    %Instance{}
    |> Instance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a instance.

  ## Examples

      iex> update_instance(instance, %{field: new_value})
      {:ok, %Instance{}}

      iex> update_instance(instance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_instance(%Instance{} = instance, attrs) do
    instance
    |> Instance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a instance.

  ## Examples

      iex> delete_instance(instance)
      {:ok, %Instance{}}

      iex> delete_instance(instance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_instance(%Instance{} = instance) do
    Repo.delete(instance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking instance changes.

  ## Examples

      iex> change_instance(instance)
      %Ecto.Changeset{data: %Instance{}}

  """
  def change_instance(%Instance{} = instance, attrs \\ %{}) do
    Instance.changeset(instance, attrs)
  end

  def list_instances_for(record) do
    case record do
      %Renaissance.World.Room{id: room_id} -> list_instances_for_room(room_id)
      %Renaissance.World.Character{id: character_id} -> list_instances_for_character(character_id)
      %Renaissance.Auth.User{id: user_id} -> list_instances_for_user(user_id)
      # TODO - raise an error if record is not a recognized type
    end
  end

  def list_instances_for_user(userid) do
    Instance
    |> Ecto.Query.where(userid: ^userid)
    |> Repo.all(scan: true) # TODO - add an index and remove scan here.
  end

  def list_instances_for_room(roomid) do
    Instance
    |> Ecto.Query.where(roomid: ^roomid)
    |> Repo.all(scan: true) # TODO - add an index and remove scan here.
  end

  def list_instances_for_character(characterid) do
    Instance
    |> Ecto.Query.where(characterid: ^characterid)
    |> Repo.all(scan: true) # TODO - add an index and remove scan here.
  end
end
