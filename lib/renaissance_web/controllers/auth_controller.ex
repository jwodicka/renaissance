defmodule RenaissanceWeb.AuthController do
  use RenaissanceWeb, :controller
  alias RenaissanceWeb.Router.Helpers

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Renaissance.User.find_or_create(auth.uid, auth.info.name) do
      {:ok, user} ->
        conn
        # |> put_flash(:info, "Hey, I know who you are!")
        |> put_flash(:info, user.name)
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
