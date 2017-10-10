class NgsiSubscription < ApplicationRecord
  belongs_to :service
  validates_presence_of :name
  validates_presence_of :entities
  validates_presence_of :attr
  validates_presence_of :reference
  validates_presence_of :duration
  validates_presence_of :notifyConditions
  validates_presence_of :throttling
end
