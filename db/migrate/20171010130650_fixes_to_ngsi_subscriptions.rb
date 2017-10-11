class FixesToNgsiSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :ngsi_subscriptions, :description, :string
    add_column :ngsi_subscriptions, :subject, :string
    add_column :ngsi_subscriptions, :notification, :string
    add_column :ngsi_subscriptions, :expires, :string
    remove_column :ngsi_subscriptions, :entities, :string
    remove_column :ngsi_subscriptions, :attr, :string
    remove_column :ngsi_subscriptions, :reference, :string
    remove_column :ngsi_subscriptions, :duration, :string
    remove_column :ngsi_subscriptions, :notifyConditions, :string
  end
end
