class V1::ServicesController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_role
  before_action :set_service, only: [:show, :update, :destroy]

  # Swagger specs
  swagger_controller :services, "Service Management"

  def self.add_common_params(api)
    api.response :unauthorized, "The actor does not have permission to perform this action"
    api.response :invalid_token, "The provided API token is invalid"
    api.response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :index do |api|
    V1::ServicesController::add_common_params(api)
    summary "Fetches Services"
    notes "This lists all the Services belonging to a given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    response :ok, "Success", :Service
  end

  swagger_api :show do |api|
    V1::ServicesController::add_common_params(api)
    summary "Fetches a specific Service"
    notes "This fetches the Service matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Service Id"
    response :ok, "Success", :Service
    response :not_found, "Service not found"
  end

  swagger_api :create do |api|
    V1::ServicesController::add_common_params(api)
    summary "Register a new Service"
    notes "This registers a new Service in the given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :form, :name, :string, :required, "A name for the Service"
    param :form, :configuration, :string, :required, "The configuration environment variables (JSON format)"
    param :form, :status, :string, :required, "The status of the service (active, inactive)"
    param :form, :managed, :boolean, :required, "Whether this service is managed (deployed by MasterMind) or unmanaged (registered if already deployed)"
    param :form, :endpoint, :string, :required, "The endpoint of the Service"
    param :form, :latitude, :string, :required, "The Latitude of the Service's location"
    param :form, :longitude, :string, :required, "The Longitude of the Service's location"
    param :form, :service_type_id, :integer, :required, "The id of the Service Type this Service belongs to"
    param :form, :docker_service_id, :string, :required, "The id of the service inside Docker"
    param :form, :cluster_id, :integer, :required, "The id of the Cluster this Service belongs to"
    response :ok, "Success", :Service
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do |api|
    V1::ServicesController::add_common_params(api)
    summary "Updates a Service"
    notes "This updates the Service matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Service Id"
    param :form, :name, :string, :required, "A name for the Service"
    param :form, :configuration, :string, :required, "The configuration environment variables (JSON format)"
    param :form, :status, :string, :required, "The status of the service (active, inactive)"
    param :form, :managed, :boolean, :required, "Whether this service is managed (deployed by MasterMind) or unmanaged (registered if already deployed)"
    param :form, :endpoint, :string, :required, "The endpoint of the Service"
    param :form, :latitude, :string, :required, "The Latitude of the Service's location"
    param :form, :longitude, :string, :required, "The Longitude of the Service's location"
    param :form, :service_type_id, :integer, :required, "The id of the Service Type this Service belongs to"
    param :form, :docker_service_id, :string, :required, "The id of the service inside Docker"
    param :form, :cluster_id, :integer, :required, "The id of the Cluster this Service belongs to"
    response :ok, "Success", :Service
    response :not_found, "Service not found"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do |api|
    V1::ServicesController::add_common_params(api)
    summary "Deletes a Service"
    notes "This deletes the Service matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Service Id"
    response :ok, "Success", :Service
    response :not_found, "Service not found"
  end

  # GET /projects/:project_id/services
  def index
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view this project's services" }, :forbidden)
      return
    end
    json_response(@project.services)
  end

  # GET /projects/:project_id/services/:id
  def show
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view this project's services" }, :forbidden)
      return
    end
    json_response(@service)
  end

  # POST /projects/:project_id/services
  def create
    if (@role.nil? or !(@role.services_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to create a service in this project" }, :forbidden)
      return
    end
    service = @project.services.create!(service_params)
    json_response(service, :created)
  end

  # PUT /projects/:project_id/services/:id
  def update
    if (@role.nil? or !(@role.services_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to create a service in this project" }, :forbidden)
      return
    end
    @service.update(service_params)
    head :no_content
  end

  # DELETE /projects/:project_id/services/:id
  def destroy
    if (@role.nil? or !(@role.services_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to create a service in this project" }, :forbidden)
      return
    end
    @service.destroy
    head :no_content
  end

  def secure_service
    if (@role.nil? or !(@role.services_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to secure a service in this project" }, :forbidden)
      return
    end
    api = params[:payload][:api]
    api_key = api[:'X-Api-Key']
    admin_auth_token = api[:'X-Admin-Auth-Token']
    host = api[:host]
    payload =
          {
            'api': {
              'name': api[:name],
              'sort_order': 100000,
              'backend_protocol': 'http',
              'frontend_host': api[:frontend_host],
              'backend_host': api[:backend_host],
              'servers': [
                {
                  'host': api[:servers][0][:host],
                  'port': Integer(api[:servers][0][:port])
                }
              ],
              'url_matches': [
                {
                  'frontend_prefix': api[:url_matches][0][:frontend_prefix],
                  'backend_prefix': api[:url_matches][0][:backend_prefix]
                }
              ],
              'balance_algorithm': 'least_conn',
              'settings': {
                'require_https': 'required_return_error',
                'require_idp': 'fiware-oauth2',
                'disable_api_key': 'false',
                'api_key_verification_level': 'none',
                'rate_limit_mode': 'unlimited',
                'error_templates': {},
                'error_data': {}
              }
            }
          }
    headers = {
      'Accept' => 'application/json',
      'X-Api-Key' => api_key,
      'X-Admin-Auth-Token' => admin_auth_token
    }
    # puts JSON.pretty_generate(payload)
    begin
        response = RestClient::Request.execute(
          :url => host + '/api-umbrella/v1/apis',
          :method => :post,
          :headers => headers,
          :verify_ssl => false, #TODO implement the ssl mechanism
          :payload => payload
        )
        id = JSON(response.body)['api']['id']
        puts 'API backend id: ' + id
        #json_response(JSON(response.body)['api']['id'], :created)
        publish_data = {
        "config": {
          "apis": {
            :"#{JSON(response.body)['api']['id']}" => {
              "publish": "1"
            }
          }
        }
      }
        response = RestClient::Request.execute(
          :url => host + '/api-umbrella/v1/config/publish',
          :method => :post,
          :headers => headers,
          :verify_ssl => false, #TODO implement the ssl mechanism
          :payload => publish_data
        )
    rescue Exception => e
      # If error, return it to the client
      puts e
      json_response({message: e}, :unprocessable_entity)
    end


  end

  private
  # Allowed service params
  def service_params
    params.permit(:name, :configuration, :status, :managed, :endpoint,
    :docker_service_id, :latitude, :longitude, :service_type_id, :cluster_id, :secured)
  end

  # Set service when needed
  def set_service
    @service = Service.find(params[:id]) if @project
  end

  # Set project when needed
  def set_project
    @project = Project.find(params[:project_id])
  end

  # Set role if needed
  def set_role
    @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
  end

end
