class Role < ApplicationRecord
  belongs_to :role_level
  belongs_to :project
  belongs_to :actor
  validates_inclusion_of :clusters_permissions, :in => [true, false]
  validates_inclusion_of :services_permissions, :in => [true, false]
  validates_inclusion_of :subscriptions_permissions, :in => [true, false]
end
