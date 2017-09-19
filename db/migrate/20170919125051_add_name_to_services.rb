class AddNameToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :name, :string
  end
end
