class CreateClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.string :name
      t.string :description
      t.string :endpoint
      t.string :cert
      t.string :key
      t.string :ca
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
