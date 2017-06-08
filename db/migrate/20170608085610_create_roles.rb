class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.references :role_level, foreign_key: true
      t.references :project, foreign_key: true
      t.references :actor, foreign_key: true

      t.timestamps
    end
  end
end
