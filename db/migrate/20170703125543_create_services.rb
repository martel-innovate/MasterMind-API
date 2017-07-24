class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.text :configuration
      t.string :status
      t.boolean :managed
      t.text :endpoint
      t.float :latitude
      t.float :longitude
      t.references :project, foreign_key: true
      t.references :service_type, foreign_key: true

      t.timestamps
    end
  end
end
