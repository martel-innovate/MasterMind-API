class AddClusterToServices < ActiveRecord::Migration[5.1]
  def change
    add_reference :services, :cluster, foreign_key: true
  end
end
