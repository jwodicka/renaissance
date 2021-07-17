defmodule Renaissance.TranscriptTest do
  use Renaissance.DataCase

  alias Renaissance.Transcript

  describe "messages" do
    alias Renaissance.Transcript.Message

    @valid_attrs %{characterid: "some characterid", content: "some content", timestamp: 42, userid: "some userid"}
    @update_attrs %{characterid: "some updated characterid", content: "some updated content", timestamp: 43, userid: "some updated userid"}
    @invalid_attrs %{characterid: nil, content: nil, timestamp: nil, userid: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transcript.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Transcript.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Transcript.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Transcript.create_message(@valid_attrs)
      assert message.characterid == "some characterid"
      assert message.content == "some content"
      assert message.timestamp == 42
      assert message.userid == "some userid"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transcript.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = Transcript.update_message(message, @update_attrs)
      assert message.characterid == "some updated characterid"
      assert message.content == "some updated content"
      assert message.timestamp == 43
      assert message.userid == "some updated userid"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Transcript.update_message(message, @invalid_attrs)
      assert message == Transcript.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Transcript.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Transcript.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Transcript.change_message(message)
    end
  end
end
