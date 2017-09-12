class Service < ApplicationRecord

  belongs_to :project
  belongs_to :cluster
  belongs_to :service_type

  validates_presence_of :configuration, :status, :endpoint, :docker_service_id, :latitude, :longitude
  validates_inclusion_of :managed, :in => [true, false]

end
