class AddVersionToServiceType < ActiveRecord::Migration[5.1]
  def change
    add_column :service_types, :version, :string
  end
end
