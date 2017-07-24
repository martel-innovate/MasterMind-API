class ServiceType < ApplicationRecord
  has_many :services
  validates_presence_of :name, :service_protocol_type, :ngsi_version, :configuration_template, :deploy_template
end
