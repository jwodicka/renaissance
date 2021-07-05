defmodule Renaissance.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters,
      primary_key: false, # Don't use the default SQL-style primary key
      options: [
        provisioned_throughput: [1,1]  # [read_capacity, write_capacity]
      ]
    ) do
      add :id, :string, primary_key: true
      add :admin, :string  # This should create a new index

    end
  end
end
