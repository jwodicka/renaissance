defmodule RenaissanceWeb.AuthController do
  use RenaissanceWeb, :controller

  plug Ueberauth

  alias Renaissance.Auth

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
    case Auth.find_or_create_user_by_authid(auth.uid, %{name: auth.info.name}) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome, " <> user.name <> "!")
        |> put_session(:current_user, user)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
