class NgsiSubscription < ApplicationRecord
  belongs_to :service
  validates_presence_of :subscription_id
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :subject
  validates_presence_of :notification
  validates_presence_of :expires
  validates_presence_of :throttling
  validates_presence_of :status
end
