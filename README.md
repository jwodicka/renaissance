# Renaissance

Renaissance is a system for text-based embodied roleplaying, It's meant for people to create virtual environments in which they can collaboratively tell stories by taking on the roles of certain characters. The primary focus is on free-form in-character actions, but there's also some support for mechanical systems and out-of-character communication to support this kind of roleplaying.

# Starting the server

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Make sure local DynamoDB is running
  * Make sure you have valid config in `dev.secrets.exs`
    * TODO: Notes on how to set up this file and what needs to be there.
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Local DynamoDB

To start DynamoDB locally:
  * You'll need docker running locally. This is beyond the scope of this readme.
  * Start DynamoDB on localhost:8000 with: `docker run -p 8000:8000 amazon/dynamodb-local`

First setup:
  * The very first time you use a fresh Dynamo instance, run `mix ecto.migrate --step 0`
    to set up the table used for migrations.
  * Whenever there is a migration to run, run `mix ecto.migrate` to do it.

# Phoenix Default Info

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
