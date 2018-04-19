class Service < ApplicationRecord
  belongs_to :project
  belongs_to :service_type
  has_many :ngsi_subscriptions, dependent: :destroy

  validates_presence_of :name, :configuration, :status, :endpoint, :docker_service_id, :latitude, :longitude
  validates_inclusion_of :managed, :in => [true, false]
  validates_inclusion_of :secured, :in => [true, false]
end
