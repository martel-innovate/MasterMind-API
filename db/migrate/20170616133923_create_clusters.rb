class CreateClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.string :name
      t.text :description
      t.string :endpoint
      t.text :cert
      t.text :key
      t.text :ca
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
