defmodule Renaissance.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RenaissanceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Renaissance.PubSub},
      # Start the Endpoint (http/https)
      RenaissanceWeb.Endpoint,
      # Start a worker by calling: Renaissance.Worker.start_link(arg)
      # {Renaissance.Worker, arg}
      {Counter, 0}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Renaissance.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RenaissanceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
