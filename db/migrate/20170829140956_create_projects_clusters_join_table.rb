class CreateProjectsClustersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :projects, :clusters
  end
end
