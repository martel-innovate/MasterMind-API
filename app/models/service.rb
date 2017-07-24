class Service < ApplicationRecord

  belongs_to :project
  belongs_to :service_type

  validates_presence_of :configuration, :status, :managed, :endpoint, :docker_service_id, :latitude, :longitude

end
