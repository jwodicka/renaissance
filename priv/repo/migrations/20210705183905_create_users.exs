defmodule Renaissance.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users,
      primary_key: false, # Don't use the default SQL-style primary key
      options: [
        provisioned_throughput: [1,1]  # [read_capacity, write_capacity]
      ]
    ) do
      add :id, :string, primary_key: true
      add :authid, :string
    end

  end
end
