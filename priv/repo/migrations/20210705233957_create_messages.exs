defmodule Renaissance.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages,
      primary_key: false,
      options: [
        provisioned_throughput: [1,1]  # [read_capacity, write_capacity]
      ]
    ) do
      add :channelid, :string, primary_key: true
      add :timestamp, :string, range_key: true
    end

  end
end
