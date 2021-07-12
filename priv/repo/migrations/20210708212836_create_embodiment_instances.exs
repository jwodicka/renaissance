defmodule Renaissance.Repo.Migrations.CreateEmbodimentInstances do
  use Ecto.Migration

  def change do
    create table(:embodiment_instances,
      primary_key: false,
      options: [
        # global_indexes: [
        #   # [ index_name: "userid",
        #   #   keys: [:userid],
        #   #   provisioned_throughput: [1, 1]
        #   # ],
        #   # We can add this when we need to search on characterid
        #   # [ index_name: "characterid",
        #   #   keys: [:characterid],
        #   #   provisioned_throughput: [1, 1]
        #   # ],
        # ],
        provisioned_throughput: [1,1]  # [read_capacity, write_capacity]
      ]
    ) do
      add :id, :string, primary_key: true
      add :instance_id, :string, range_key: true
      add :userid, :string
      add :characterid, :string
    end

  end
end
