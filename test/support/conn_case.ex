defmodule RenaissanceWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use RenaissanceWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import RenaissanceWeb.ConnCase

      alias RenaissanceWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint RenaissanceWeb.Endpoint
    end
  end

  @standard_user %Renaissance.Auth.User{
    id: "some fake id",
    authid: "test_user_standard",
    name: "Standard User",
    sysadmin: false
  }
  @sysadmin_user %Renaissance.Auth.User{
    id: "a different fake id",
    authid: "test_user_admin",
    name: "Admin User",
    sysadmin: true
  }

  def standard_user, do: @standard_user

  setup tags do
    conn = Phoenix.ConnTest.build_conn()

    conn =
      case tags[:auth] do
        true -> Plug.Test.init_test_session(conn, current_user: @standard_user)
        :admin -> Plug.Test.init_test_session(conn, current_user: @sysadmin_user)
        nil -> conn
      end

    {:ok, conn: conn}
  end
end
