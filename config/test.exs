use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :renaissance, RenaissanceWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Config to connect to a locally-running copy of dynamodb for use in tests.
# Local dynamodb will accept any credentials.
config :renaissance, Renaissance.Repo,
  access_key_id: "localkey",
  secret_access_key: "localsecret",
  region: "us-west-2",
  dynamodb_local: true,
  # Because scans are expensive, we must opt into them.
  scan_tables: ["schema_migrations"],
  # ExAws option to enable debug on aws http request.
  debug_requests: false,
  dynamodb: [
    scheme: "http://",
    host: "localhost",
    port: 8000,
    region: "us-west-2"
  ]

# The Ecto DynamoDB adapter uses its own logging, so we'll disable it.
config :ecto_adapters_dynamodb, log_levels: []
