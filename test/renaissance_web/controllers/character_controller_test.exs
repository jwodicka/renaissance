defmodule RenaissanceWeb.CharacterControllerTest do
  use RenaissanceWeb.ConnCase

  alias Renaissance.World

  @create_attrs %{admin: standard_user().id, description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{admin: nil, description: nil, name: nil}

  def fixture(:character) do
    {:ok, character} = World.create_character(@create_attrs)
    character
  end

  @moduletag :auth
  # TODO: Add tests that handle interactions from:
  # - an admin user
  # - a user who is not the character's owner
  # - a user who is not logged in

  describe "index" do
    test "lists all characters", %{conn: conn} do
      conn = get(conn, Routes.character_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Characters"
    end
  end

  describe "new character" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.character_path(conn, :new))
      assert html_response(conn, 200) =~ "New Character"
    end
  end

  describe "create character" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.character_path(conn, :create), character: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.character_path(conn, :show, id)

      conn = get(conn, Routes.character_path(conn, :show, id))
      assert html_response(conn, 200) =~ @create_attrs.name
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.character_path(conn, :create), character: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Character"
    end
  end

  describe "edit character" do
    setup [:create_character]

    test "renders form for editing chosen character", %{conn: conn, character: character} do
      conn = get(conn, Routes.character_path(conn, :edit, character))
      assert html_response(conn, 200) =~ "Edit Character"
    end
  end

  describe "update character" do
    setup [:create_character]

    test "redirects when data is valid", %{conn: conn, character: character} do
      conn = put(conn, Routes.character_path(conn, :update, character), character: @update_attrs)
      assert redirected_to(conn) == Routes.character_path(conn, :show, character)

      conn = get(conn, Routes.character_path(conn, :show, character))
      assert html_response(conn, 200) =~ @update_attrs.name
    end

    test "renders errors when data is invalid", %{conn: conn, character: character} do
      conn = put(conn, Routes.character_path(conn, :update, character), character: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Character"
    end
  end

  describe "delete character" do
    setup [:create_character]

    test "deletes chosen character", %{conn: conn, character: character} do
      conn = delete(conn, Routes.character_path(conn, :delete, character))
      assert redirected_to(conn) == Routes.character_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.character_path(conn, :show, character))
      end
    end
  end

  defp create_character(_) do
    character = fixture(:character)
    %{character: character}
  end
end
