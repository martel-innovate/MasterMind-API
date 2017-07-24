class CreateServiceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :service_types do |t|
      t.string :service_protocol_type
      t.string :ngsi_version
      t.text :configuration_template
      t.text :deploy_template

      t.timestamps
    end
  end
end
