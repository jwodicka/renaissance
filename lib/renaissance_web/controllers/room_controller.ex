defmodule RenaissanceWeb.RoomController do
  use RenaissanceWeb, :controller

  alias Renaissance.World
  alias Renaissance.World.Room
  alias Renaissance.Transcript

  def index(conn, _params) do
    rooms = World.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = World.change_room(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case World.create_room(room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = World.get_room!(id)
    characters = Enum.map(room.characters, fn id -> World.get_character!(id) end)
    messages = case Transcript.get_room!(id).messages do
      nil -> []
      m -> m
    end
    render(conn, "show.html", room: room, characters: characters, messages: messages)
  end

  def edit(conn, %{"id" => id}) do
    room = World.get_room!(id)
    changeset = World.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = World.get_room!(id)

    case World.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = World.get_room!(id)
    {:ok, _room} = World.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
