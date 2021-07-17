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

      setup_all [:get_aws_config, :get_table_info]
      setup [:purge_all_tables]

      defp get_aws_config(_context) do
        [aws_config: Ecto.Adapters.DynamoDB.ex_aws_config(Renaissance.Repo)]
      end

      defp get_table_options(table, config) do
        %{"Table" => %{"KeySchema" => keyschema}} =
          ExAws.Dynamo.describe_table(table) |> ExAws.request!(config)
        case keyschema do
          [
            %{"AttributeName" => hashkey, "KeyType" => "HASH"}
          ] -> [projection_expression: "#{hashkey}"]

          [
            %{"AttributeName" => hashkey, "KeyType" => "HASH"},
            %{"AttributeName" => rangekey, "KeyType" => "RANGE"}
          ] -> [projection_expression: "#{hashkey}, #{rangekey}"]
        end
      end

      defp get_table_info(context) do
        config = context[:aws_config]
        %{"TableNames" => tables} = ExAws.Dynamo.list_tables() |> ExAws.request!(config)

        # Ignore the schema_migrations table, since it's not a real table
        tables = Enum.reject(tables, &(&1 == "schema_migrations"))

        table_opts = Map.new(tables, fn table -> {table, get_table_options(table, config)} end)

        [table_list: tables, table_opts: table_opts]
      end

      defp purge_all_tables(context) do
        config = context[:aws_config]
        tables = context[:table_list]
        table_opts = context[:table_opts]

        for table <- tables do
          options = table_opts[table]

          %{"Count" => count, "Items" => records} = ExAws.Dynamo.scan(table, options) |> ExAws.request!(config)
          for record <- records do
            record = ExAws.Dynamo.Decoder.decode(record)
            ExAws.Dynamo.delete_item(table, record) |> ExAws.request!(config)
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
