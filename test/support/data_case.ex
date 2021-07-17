defmodule Renaissance.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.
  You may define functions here to be used as helpers in
  your tests.
  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Renaissance.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Renaissance.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Renaissance.DataCase

      setup do
        alias ExAws.Dynamo
        import Ecto.Adapters.DynamoDB

        # Probably we can read this config once as we're starting up the tests.
        config = Ecto.Adapters.DynamoDB.ex_aws_config(Renaissance.Repo)
        %{"TableNames" => tables} = Dynamo.list_tables() |> ExAws.request!(config)

        for table <- tables, table != "schema_migrations" do
          %{"Table" => %{"KeySchema" => keyschema}} = Dynamo.describe_table(table) |> ExAws.request!(config)
          options = case keyschema do
            [
              %{"AttributeName" => hashkey, "KeyType" => "HASH"}
            ] -> [projection_expression: "#{hashkey}"]

            [ # 'timestamp' is a reserved word, so we need to be slightly fancier here.
              %{"AttributeName" => hashkey, "KeyType" => "HASH"},
              %{"AttributeName" => "timestamp", "KeyType" => "RANGE"}
            ] -> [
              projection_expression: "#{hashkey}, #timestamp_key",
              expression_attribute_names: %{"#timestamp_key" => "timestamp"}
            ]

            [
              %{"AttributeName" => hashkey, "KeyType" => "HASH"},
              %{"AttributeName" => rangekey, "KeyType" => "RANGE"}
            ] -> [projection_expression: "#{hashkey}, #{rangekey}"]
          end

          %{"Count" => count, "Items" => records} = Dynamo.scan(table, options) |> ExAws.request!(config)
          for record <- records do
            record = ExAws.Dynamo.Decoder.decode(record)
            Dynamo.delete_item(table, record, options) |> ExAws.request!(config)
          end
        end

        :ok
      end
    end
  end

  setup _tags do
    # :ok = Renaissance.Repo.start_link()

    # :ok = Ecto.Adapters.SQL.Sandbox.checkout(Renaissance.Repo)

    # unless tags[:async] do
    #   Ecto.Adapters.SQL.Sandbox.mode(Renaissance.Repo, {:shared, self()})
    # end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.
      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
