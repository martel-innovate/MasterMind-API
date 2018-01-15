class V1::ServicesController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
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
    authorize @project
    json_response(@project.services)
  end

  # GET /projects/:project_id/services/:id
  def show
    authorize @project
    json_response(@service)
  end

  # POST /projects/:project_id/services
  def create
    authorize @project
    service = @project.services.create!(service_params)
    json_response(service, :created)
  end

  # PUT /projects/:project_id/services/:id
  def update
    authorize @project
    @service.update(service_params)
    head :no_content
  end

  # DELETE /projects/:project_id/services/:id
  def destroy
    authorize @project
    @service.destroy
    head :no_content
  end

  private

  # Allowed service params
  def service_params
    params.permit(:name, :configuration, :status, :managed, :endpoint,
    :docker_service_id, :latitude, :longitude, :service_type_id, :cluster_id)
  end

  # Set service when needed
  def set_service
    @service = Service.find(params[:id]) if @project
  end

  # Set project when needed
  def set_project
    @project = Project.find(params[:project_id])
  end

end
