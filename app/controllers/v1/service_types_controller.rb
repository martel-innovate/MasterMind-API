class V1::ServiceTypesController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_service_type, only: [:show, :update, :destroy]

  swagger_controller :service_types, "Service Types Management"

  def self.add_common_params(api)
    api.response :unauthorized, "The actor does not have permission to perform this action"
    api.response :invalid_token, "The provided API token is invalid"
    api.response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :index do |api|
    V1::ServiceTypesController::add_common_params(api)
    summary "Fetches all Service Types"
    notes "This lists all the Service Types"
    response :ok, "Success", :ServiceType
  end

  swagger_api :show do |api|
    V1::ServiceTypesController::add_common_params(api)
    summary "Fetches a specific Service Type"
    notes "This fetches the Service Type matching the given id"
    param :path, :id, :integer, :required, "Service Type Id"
    response :ok, "Success", :ServiceType
    response :not_found, "Service Type not found"
  end

  swagger_api :create do |api|
    V1::ServiceTypesController::add_common_params(api)
    summary "Creates a Service Type"
    notes "This creates a new Service Type"
    param :form, :name, :string, :required, "The name of this Service Type"
    param :form, :service_protocol_type, :string, :required, "The protcol type of this Service Type"
    param :form, :ngsi_version, :string, :required, "The NGSI Version of this Service Type"
    param :form, :configuration_template, :string, :required, "The configuration template (the mastermind.yml file) of this Service Type"
    param :form, :deploy_template, :string, :required, "The deploy template (the docker-compose.yml file) of this Service Type"
    response :ok, "Success", :ServiceType
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do |api|
    V1::ServiceTypesController::add_common_params(api)
    summary "Updates a Service Type"
    notes "This updates the Service Type matching the given id"
    param :path, :id, :integer, :required, "Service Type Id"
    param :form, :name, :string, :optional, "The name of this Service Type"
    param :form, :service_protocol_type, :string, :optional, "The protcol type of this Service Type"
    param :form, :ngsi_version, :string, :optional, "The NGSI Version of this Service Type"
    param :form, :configuration_template, :string, :optional, "The configuration template (the mastermind.yml file) of this Service Type"
    param :form, :deploy_template, :string, :optional, "The deploy template (the docker-compose.yml file) of this Service Type"
    response :ok, "Success", :ServiceType
    response :not_found, "Service Type not found"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do |api|
    V1::ServiceTypesController::add_common_params(api)
    summary "Deletes a Service Type"
    notes "This deletes the Service Type matching the given id"
    response :ok, "Success", :ServiceType
    param :path, :id, :integer, :required, "Service Type Id"
    response :not_found, "Service Type not found"
  end

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
