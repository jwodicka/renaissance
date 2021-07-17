defmodule Renaissance.TranscriptTest do
  use Renaissance.DataCase

  alias Renaissance.Transcript

  describe "messages" do
    alias Renaissance.Transcript.Message

    @valid_attrs %{channelid: "some channelid", characterid: "some characterid", content: "some content", userid: "some userid"}
    @update_attrs %{characterid: "some updated characterid", content: "some updated content", userid: "some updated userid"}
    @invalid_attrs %{channelid: nil, characterid: nil, content: nil, userid: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transcript.create_message()

      message
    end

    test "list_messages_by_channel/1 returns all messages for that channel" do
      message = message_fixture()
      assert Transcript.list_messages_by_channel(message.channelid) == [message]
    end

    test "get_message!/2 returns the message with given id and timestamp" do
      message = message_fixture()
      assert Transcript.get_message!(message.channelid, message.sentat) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Transcript.create_message(@valid_attrs)
      assert message.channelid == "some channelid"
      assert message.characterid == "some characterid"
      assert message.content == "some content"
      # TODO - assert message.sentat is not nil
      assert message.userid == "some userid"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transcript.create_message(@invalid_attrs)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Transcript.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Transcript.get_message!(message.channelid, message.sentat) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Transcript.change_message(message)
    end
  end
end
