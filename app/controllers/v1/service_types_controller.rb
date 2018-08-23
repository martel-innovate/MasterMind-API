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
    if params["project_id"].present?
      @project = Project.find(params["project_id"])
      @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
      if @role.nil? and !current_actor.superadmin
        json_response({ message: "You don't have permission to view the service types for this project" }, :unauthorized)
        return
      else
        @service_types = ServiceType.where(is_imported: true, project_id: params["project_id"])
        json_response(@service_types)
        return
      end
    end
    @service_types = ServiceType.where(is_imported: false)
    json_response(@service_types)
  end

  # POST /service_types
  def create
    if params["is_imported"] and params["project_id"] != 0
      @project = Project.find(params["project_id"])
      @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
      if @role.nil? and !current_actor.superadmin
        json_response({ message: "You don't have permission to create service types for this project" }, :unauthorized)
        return
      else
        @service_type = ServiceType.create!(service_type_params)
        json_response(@service_type, :created)
        return
      end
    end
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to create new service types" }, :unauthorized)
      return
    end
    @service_type = ServiceType.create!(service_type_params)
    json_response(@service_type, :created)
  end

  # GET /service_types/:id
  def show
    if @service_type.is_imported and @service_type.project_id != 0
      @project = Project.find(@service_type.project_id)
      @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
      if @role.nil? and !current_actor.superadmin
        json_response({ message: "You don't have permission to view this service type for this project" }, :unauthorized)
        return
      else
        json_response(@service_type)
        return
      end
    end
    json_response(@service_type)
  end

  # PUT /service_types/:id
  def update
    if @service_type.is_imported and @service_type.project_id != 0
      @project = Project.find(@service_type.project_id)
      @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
      if @role.nil? and !current_actor.superadmin
        json_response({ message: "You don't have permission to edit service types for this project" }, :unauthorized)
        return
      else
        @service_type.update(service_type_params)
        head :no_content
        return
      end
    end
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to edit service types" }, :unauthorized)
      return
    end
    @service_type.update(service_type_params)
    head :no_content
  end

  # DELETE /service_types/:id
  def destroy
    if @service_type.is_imported and @service_type.project_id != 0
      @project = Project.find(@service_type.project_id)
      @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
      if @role.nil? and !current_actor.superadmin
        json_response({ message: "You don't have permission to edit service types for this project" }, :unauthorized)
        return
      else
        @service_type.destroy
        head :no_content
        return
      end
    end
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to delete service types" }, :unauthorized)
      return
    end
    @service_type.destroy
    head :no_content
  end

  # /catalog/refresh
  # Update the service types from the catalog
  def updateAll
    require 'FileUtils'
    require 'find'
    require 'uri'

    if !current_actor.superadmin
      json_response({ message: "You don't have permission to update service types" }, :unauthorized)
      return
    end

    begin
      URI.parse(Settings.mastermind_catalog_repository)
      if (Dir["mastermind-services"]).length != 0 then
        FileUtils.rm_rf('mastermind-services')
      end
      system("git clone -b " + Settings.mastermind_catalog_repository_branch + " --single-branch " + Settings.mastermind_catalog_repository + " mastermind-services")

      Find.find('mastermind-services') do |path|
        if path =~ /.*mastermind\.yml$/
          directory = File.dirname(path)
          mastermindConf = YAML::load(File.open(directory+'/mastermind.yml'))
          dockerCompose = YAML::load(File.open(directory+'/docker-compose.yml'))
          serviceType = ServiceType.find_by name: mastermindConf["name"], version: mastermindConf["version"]
          if serviceType.nil?
            ServiceType.create(is_imported: false, project_id: 0, local_path: directory, name: mastermindConf["name"], description: mastermindConf["description"], version: mastermindConf["version"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(directory+'/mastermind.yml'), deploy_template: File.read(directory+'/docker-compose.yml'))
          else
            serviceType.update({is_imported: false, project_id: 0, local_path: directory, name: mastermindConf["name"], description: mastermindConf["description"], version: mastermindConf["version"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(directory+'/mastermind.yml'), deploy_template: File.read(directory+'/docker-compose.yml')})
          end
        end
      end

      json_response({ message: "Service Types Updated" }, 200)
    rescue
      json_response({ message: "Invalid Catalog Repository URI or malformed Repository" }, 400)
    end
  end

  # /catalog/import
  # Import a custom set of recipes in the catalog to be used by a single project
  def importCustomCatalog
    require 'FileUtils'
    require 'find'
    require 'uri'
    require 'tmpdir'

    @project = Project.find(params["project_id"])
    @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to update service types" }, :unauthorized)
      return
    end

    temp_dir = Dir.mktmpdir

    begin
      URI.parse(params["custom_catalog_uri"])
      if params["custom_catalog_branch"].present?
        repo_branch = params["custom_catalog_branch"]
      else
        repo_branch = 'master'
      end

      system("git clone -b " + repo_branch + " --single-branch " + params["custom_catalog_uri"] + " " + temp_dir + "/mastermind-services")

      Find.find(temp_dir + "/mastermind-services") do |path|
        if path =~ /.*mastermind\.yml$/
          directory = File.dirname(path)
          mastermindConf = YAML::load(File.open(directory+'/mastermind.yml'))
          dockerCompose = YAML::load(File.open(directory+'/docker-compose.yml'))
          serviceType = ServiceType.find_by name: mastermindConf["name"], version: mastermindConf["version"], is_imported: true, project_id: @project.id
          if serviceType.nil?
            ServiceType.create(is_imported: true, project_id: @project.id, local_path: directory, name: mastermindConf["name"], description: mastermindConf["description"], version: mastermindConf["version"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(directory+'/mastermind.yml'), deploy_template: File.read(directory+'/docker-compose.yml'))
          else
            serviceType.update({is_imported: true, project_id: @project.id, local_path: directory, name: mastermindConf["name"], description: mastermindConf["description"], version: mastermindConf["version"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(directory+'/mastermind.yml'), deploy_template: File.read(directory+'/docker-compose.yml')})
          end
        end
      end

      json_response({ message: "Service Types imported" }, 200)
    rescue
      json_response({ message: "Invalid Catalog Repository URI or malformed Repository" }, 400)
    ensure
      FileUtils.remove_entry_secure temp_dir
    end
  end

  private

  # Allowed service type params
  def service_type_params
    params.permit(:name, :version, :service_protocol_type, :ngsi_version, :configuration_template, :deploy_template, :is_imported, :project_id)
  end

  # Set service type when needed
  def set_service_type
    @service_type = ServiceType.find(params[:id])
  end

end
