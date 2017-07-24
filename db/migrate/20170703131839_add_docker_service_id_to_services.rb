class AddDockerServiceIdToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :docker_service_id, :string
  end
end
