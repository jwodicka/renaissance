defmodule RenaissanceWeb.Router do
  use RenaissanceWeb, :router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_user
  end

  # Must be called after browser pipeline
  def require_login(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: "/")
      |> halt()
    end
  end

  def assign_user(conn, _opts) do
    conn
    |> assign(:current_user, get_session(conn, :current_user))
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RenaissanceWeb do
    pipe_through :browser

    get "/", PageController, :index

    pipe_through :require_login

    # TODO: Strip out the count subsystem
    get "/count", CountController, :index
    get "/logout", AuthController, :logout

    resources "/rooms", RoomController
    post "/rooms/:room/send", RoomController, :send
    resources "/characters", CharacterController
    resources "/users", UserController

    resources "/instances",
              InstanceController,
              only: [:index, :new, :create],
              name: "uc",
              param: "id" do
      resources "/", InstanceController, param: "iid"
      get "/:iid/move_to/:roomid", InstanceController, :move_to_room
    end
  end

  scope "/auth", RenaissanceWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", RenaissanceWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RenaissanceWeb.Telemetry
    end
  end
end
