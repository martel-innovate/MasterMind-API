class RemoveProjectIdFromCluster < ActiveRecord::Migration[5.1]
  def change
    remove_reference :clusters, :project, foreign_key: true
  end
end
