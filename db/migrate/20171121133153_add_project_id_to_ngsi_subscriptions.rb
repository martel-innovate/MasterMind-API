class AddProjectIdToNgsiSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :ngsi_subscriptions, :project, foreign_key: true
  end
end
