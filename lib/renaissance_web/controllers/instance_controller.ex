defmodule RenaissanceWeb.InstanceController do
  use RenaissanceWeb, :controller

  alias Renaissance.Embodiment
  alias Renaissance.Embodiment.Instance
  alias Renaissance.World

  def index(conn, _params) do
    embodiment_instances = Embodiment.list_embodiment_instances()
    render(conn, "index.html", embodiment_instances: embodiment_instances)
  end

  def new(conn, _params) do
    changeset = Embodiment.change_instance(%Instance{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"instance" => instance_params}) do
    case Embodiment.create_instance(instance_params) do
      {:ok, instance} ->
        conn
        |> put_flash(:info, "Instance created successfully.")
        |> redirect(to: Routes.instance_path(conn, :show, instance))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    instance = Embodiment.get_instance!(id)
    render(conn, "show.html", instance: instance)
  end

  def show(conn, %{"uc_id" => ucid, "iid" => iid}) do
    instance = Embodiment.get_instance!(ucid, iid)

    room = World.get_room_for(instance)
    room_instances = Embodiment.list_instances_for(room)

    characters =
      Enum.map(room_instances, fn %{:characterid => id} -> World.get_character!(id) end)

    messages =
      case Renaissance.Transcript.list_messages_by_channel(room.id) do
        nil -> []
        m -> m
      end

    changeset = Renaissance.Transcript.change_message(%Renaissance.Transcript.Message{})

    render(conn, "show.html",
      instance: instance,
      room: room,
      characters: characters,
      messages: messages,
      changeset: changeset
    )
  end

  def edit(conn, %{"id" => id}) do
    instance = Embodiment.get_instance!(id)
    changeset = Embodiment.change_instance(instance)
    render(conn, "edit.html", instance: instance, changeset: changeset)
  end

  def move_to_room(conn, %{"uc_id" => ucid, "iid" => iid, "roomid" => roomid}) do
    instance = Embodiment.get_instance!(ucid, iid)

    case Embodiment.update_instance(instance, %{roomid: roomid}) do
      {:ok, _} ->
        # This knows WAAAAY too much about the routing. Extract to Routes helper somehow.
        instance_link = "/instances/#{ucid}/#{iid}"

        conn
        |> put_flash(:info, "Instance updated successfully.")
        |> redirect(to: instance_link)

      {:error, _} ->
        instance_link = "/instances/#{ucid}/#{iid}"

        conn
        |> put_flash(:info, "Something bad happened.")
        |> redirect(to: instance_link)
    end
  end

  def update(conn, %{"id" => id, "instance" => instance_params}) do
    instance = Embodiment.get_instance!(id)

    case Embodiment.update_instance(instance, instance_params) do
      {:ok, instance} ->
        conn
        |> put_flash(:info, "Instance updated successfully.")
        |> redirect(to: Routes.instance_path(conn, :show, instance))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", instance: instance, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    instance = Embodiment.get_instance!(id)
    {:ok, _instance} = Embodiment.delete_instance(instance)

    conn
    |> put_flash(:info, "Instance deleted successfully.")
    |> redirect(to: Routes.instance_path(conn, :index))
  end
end
