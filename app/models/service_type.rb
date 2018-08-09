class ServiceType < ApplicationRecord
  has_many :services
  validates_presence_of :name, :version, :service_protocol_type, :ngsi_version, :configuration_template, :deploy_template, :project_id
  validates_inclusion_of :is_imported, :in => [true, false]
end
