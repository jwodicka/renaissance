defmodule Renaissance.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms,
      primary_key: false, # Don't use the default SQL-style primary key
      options: [
        provisioned_throughput: [1,1]  # [read_capacity, write_capacity]
      ]
    ) do
      add :id, :string, primary_key: true

    end

  end
end
