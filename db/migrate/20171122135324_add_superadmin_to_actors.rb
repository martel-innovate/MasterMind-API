class AddSuperadminToActors < ActiveRecord::Migration[5.1]
  def change
    add_column :actors, :superadmin, :boolean
  end
end
