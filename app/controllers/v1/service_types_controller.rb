class V1::ServiceTypesController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_service_type, only: [:show, :update, :destroy]

  def index
    @service_types = ServiceType.all
    json_response(@service_types)
  end

  def create
    @service_type = ServiceType.create!(service_type_params)
    json_response(@service_type, :created)
  end

  def show
    json_response(@service_type)
  end

  def update
    @service_type.update(service_type_params)
    head :no_content
  end

  def destroy
    @service_type.destroy
    head :no_content
  end

  private

  def service_type_params
    params.permit(:name, :service_protocol_type, :ngsi_version, :configuration_template, :deploy_template)
  end

  def set_service_type
    @service_type = ServiceType.find(params[:id])
  end

end
