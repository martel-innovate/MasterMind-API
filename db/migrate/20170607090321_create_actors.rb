class CreateActors < ActiveRecord::Migration[5.1]
  def change
    create_table :actors do |t|
      t.string :email
      t.string :fullname
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
