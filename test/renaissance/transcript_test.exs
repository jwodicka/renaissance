defmodule Renaissance.TranscriptTest do
  use Renaissance.DataCase

  alias Renaissance.Transcript

  describe "rooms" do
    alias Renaissance.Transcript.Room

    @valid_attrs %{messages: []}
    @update_attrs %{messages: []}
    @invalid_attrs %{messages: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transcript.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Transcript.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Transcript.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Transcript.create_room(@valid_attrs)
      assert room.messages == []
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transcript.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Transcript.update_room(room, @update_attrs)
      assert room.messages == []
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Transcript.update_room(room, @invalid_attrs)
      assert room == Transcript.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Transcript.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Transcript.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Transcript.change_room(room)
    end
  end
end
