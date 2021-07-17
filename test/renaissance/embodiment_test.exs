defmodule Renaissance.EmbodimentTest do
  use Renaissance.DataCase

  alias Renaissance.Embodiment

  describe "embodiment_instances" do
    alias Renaissance.Embodiment.Instance

    @valid_attrs %{characterid: "some characterid", roomid: "some roomid", userid: "some userid"}
    @update_attrs %{roomid: "some updated roomid"}
    @invalid_attrs %{characterid: nil, roomid: nil, userid: nil}

    def instance_fixture(attrs \\ %{}) do
      {:ok, instance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Embodiment.create_instance()

      instance
    end

    test "list_embodiment_instances/0 returns all embodiment_instances" do
      instance = instance_fixture()
      assert Embodiment.list_embodiment_instances() == [instance]
    end

    test "get_instance!/1 returns the instance with given id" do
      instance = instance_fixture()
      assert Embodiment.get_instance!(instance.id) == instance
    end

    test "create_instance/1 with valid data creates a instance" do
      assert {:ok, %Instance{} = instance} = Embodiment.create_instance(@valid_attrs)
      assert instance.characterid == "some characterid"
      assert instance.roomid == "some roomid"
      assert instance.userid == "some userid"
    end

    test "create_instance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Embodiment.create_instance(@invalid_attrs)
    end

    test "update_instance/2 with valid data updates the instance" do
      instance = instance_fixture()
      assert {:ok, %Instance{} = instance} = Embodiment.update_instance(instance, @update_attrs)
      assert instance.roomid == "some updated roomid"
    end

    test "update_instance/2 with invalid data returns error changeset" do
      instance = instance_fixture()
      assert {:error, %Ecto.Changeset{}} = Embodiment.update_instance(instance, @invalid_attrs)
      assert instance == Embodiment.get_instance!(instance.id)
    end

    test "delete_instance/1 deletes the instance" do
      instance = instance_fixture()
      assert {:ok, %Instance{}} = Embodiment.delete_instance(instance)
      assert_raise Ecto.NoResultsError, fn -> Embodiment.get_instance!(instance.id) end
    end

    test "change_instance/1 returns a instance changeset" do
      instance = instance_fixture()
      assert %Ecto.Changeset{} = Embodiment.change_instance(instance)
    end
  end
end
