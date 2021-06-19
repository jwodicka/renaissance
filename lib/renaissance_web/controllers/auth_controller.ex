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
    conn
    |> put_flash(:info, "Hey, I know who you are!")
    |> redirect(to: "/")
  end
end
