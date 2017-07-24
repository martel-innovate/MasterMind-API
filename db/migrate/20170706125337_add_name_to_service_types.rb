class AddNameToServiceTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :service_types, :name, :string
  end
end
