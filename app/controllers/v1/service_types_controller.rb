class V1::ServiceTypesController < ApplicationController
  before_action :set_service_type, only: [:show, :update, :destroy]

  # Swagger specs
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
    param :form, :version, :string, :required, "The version of this Service Type"
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
    param :form, :version, :string, :optional, "The version of this Service Type"
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

  # GET /service_types
  def index
    @service_types = ServiceType.all
    json_response(@service_types)
  end

  # POST /service_types
  def create
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to create new service types" }, :unauthorized)
      return
    end
    @service_type = ServiceType.create!(service_type_params)
    json_response(@service_type, :created)
  end

  # GET /service_types/:id
  def show
    json_response(@service_type)
  end

  # PUT /service_types/:id
  def update
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to edit service types" }, :unauthorized)
      return
    end
    @service_type.update(service_type_params)
    head :no_content
  end

  # DELETE /service_types/:id
  def destroy
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to delete service types" }, :unauthorized)
      return
    end
    @service_type.destroy
    head :no_content
  end

  # /service_types/update
  # Update the service types from the catalog
  def updateAll
    require 'FileUtils'
    require 'find'

    if !current_actor.superadmin
      json_response({ message: "You don't have permission to update service types" }, :unauthorized)
      return
    end

    if (Dir["mastermind-services"]).length != 0 then
      FileUtils.rm_rf('mastermind-services')
    end
    `git clone https://github.com/martel-innovate/MasterMind-Service-Catalog mastermind-services`

    Find.find('mastermind-services') do |path|
      if path =~ /.*mastermind\.yml$/
        directory = File.dirname(path)
        mastermindConf = YAML::load(File.open(directory+'/mastermind.yml'))
        dockerCompose = YAML::load(File.open(directory+'/docker-compose.yml'))
        serviceType = ServiceType.find_by name: mastermindConf["name"], version: mastermindConf["version"]
        if serviceType.nil?
          ServiceType.create(local_path: directory, name: mastermindConf["name"], description: mastermindConf["description"], version: mastermindConf["version"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(directory+'/mastermind.yml'), deploy_template: File.read(directory+'/docker-compose.yml'))
        else
          serviceType.update({local_path: directory, name: mastermindConf["name"], description: mastermindConf["description"], version: mastermindConf["version"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(directory+'/mastermind.yml'), deploy_template: File.read(directory+'/docker-compose.yml')})
        end
      end
    end

    json_response({ message: "Service Types Updated" }, 200)
  end

  private

  # Allowed service type params
  def service_type_params
    params.permit(:name, :version, :service_protocol_type, :ngsi_version, :configuration_template, :deploy_template)
  end

  # Set service type when needed
  def set_service_type
    @service_type = ServiceType.find(params[:id])
  end

end
