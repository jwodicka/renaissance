defmodule RenaissanceWeb.CharacterController do
  use RenaissanceWeb, :controller

  alias Renaissance.World
  alias Renaissance.Auth.User
  alias Renaissance.World.Character
  alias Renaissance.Embodiment

  def index(conn, _params) do
    characters = World.list_characters()
    render(conn, "index.html", characters: characters)
  end

  def new(conn, _params) do
    changeset = World.change_character(%Character{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"character" => character_params}) do
    params = Map.put(character_params, "admin", conn.assigns.current_user.id)

    case World.create_character(params) do
      {:ok, character} ->
        conn
        |> put_flash(:info, "Character created successfully.")
        |> redirect(to: Routes.character_path(conn, :show, character))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp annotate_with_room_name(instance = %Embodiment.Instance{}) do
    room = World.get_room!(instance.roomid)

    instance
    |> Map.from_struct()
    |> Map.put(:room_name, room.name)
  end

  def show(conn, %{"id" => id}) do
    character = World.get_character!(id)

    # Annotate each instance with the name of its room.
    instances =
      Embodiment.list_instances_for_character(id)
      |> Enum.map(&annotate_with_room_name/1)

    render(conn, "show.html", character: character, instances: instances)
  end

  def edit(conn, %{"id" => id}) do
    character = World.get_character!(id)

    if can_edit?(conn.assigns.current_user, character) do
      changeset = World.change_character(character)
      render(conn, "edit.html", character: character, changeset: changeset)
    else
      conn
      |> put_flash(:error, "You are not authorized to edit this character.")
      |> redirect(to: Routes.character_path(conn, :show, character))
    end
  end

  def update(conn, %{"id" => id, "character" => character_params}) do
    character = World.get_character!(id)

    if can_edit?(conn.assigns.current_user, character) do
      case World.update_character(character, character_params) do
        {:ok, character} ->
          conn
          |> put_flash(:info, "Character updated successfully.")
          |> redirect(to: Routes.character_path(conn, :show, character))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", character: character, changeset: changeset)
      end
    else
      conn
      |> Plug.Conn.send_resp(:forbidden, "You are not authorized to edit this character.")
      |> halt()
    end
  end

  def delete(conn, %{"id" => id}) do
    character = World.get_character!(id)
    {:ok, _character} = World.delete_character(character)

    conn
    |> put_flash(:info, "Character deleted successfully.")
    |> redirect(to: Routes.character_path(conn, :index))
  end

  #####################################
  # PERMISSION CHECKS

  @doc """
  Returns whether the given user is authorized to edit the given character.

  Right now only the admin of a character can edit it.
  In the long run, this probably should be the responsibility of the World context.

  ## Examples

      iex> can_edit?(%Character{admin: "a"}, %User{id: "a"})
      true

      iex> can_edit?(%Character{admin: "a"}, %User{id: "b"})
      false

  future expansion:

  Inverse of can_edit for use in character pipelines:
  character
  |> editable_by?(user)

  """
  defp can_edit?(%User{id: a}, %Character{admin: a}), do: true
  # This would grant blanket sysadmin access to edit all characters.
  # Commented out for now so it's easier to test access from my sysadmin account.
  # defp can_edit?(%User{sysadmin: true}, %Character{}), do: true
  defp can_edit?(%User{}, %Character{}), do: false
end
