class CreateNgsiSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :ngsi_subscriptions do |t|
      t.string :name
      t.string :entities
      t.string :attr
      t.string :reference
      t.string :duration
      t.string :notifyConditions
      t.integer :throttling
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
