class V1::RolesController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_project_role, only: [:show, :update, :destroy]

  swagger_controller :roles, "Roles Management"

  swagger_api :index do
    summary "Fetches Roles"
    notes "This lists all the Roles belonging to a given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    response :ok, "Success", :Cluster
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :show do
    summary "Fetches a specific Role"
    notes "This fetches the Role matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    response :ok, "Success", :Role
    response :not_found, "Role not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :create do
    summary "Register a new Role"
    notes "This registers a new Role in the given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :form, :actor_id, :integer, :required, "Actor Id"
    param :form, :role_level_id, :integer, :required, "Role Level Id"
    response :ok, "Success", :Role
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do
    summary "Updates a Role"
    notes "This updates the Role matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    param :form, :actor_id, :integer, :optional, "Actor Id"
    param :form, :role_level_id, :integer, :optional, "Role Level Id"
    response :ok, "Success", :Role
    response :not_found, "Role not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do
    summary "Deletes a Role"
    notes "This deletes the Role matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    response :ok, "Success", :Role
    response :not_found, "Role not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  # GET /projects/:project_id/roles
  def index
    authorize @project
    json_response(@project.roles)
  end

  # GET /projects/:project_id/roles/:id
  def show
    authorize @project
    json_response(@role)
  end

  # POST /projects/:project_id/roles
  def create
    authorize @project
    @project.roles.create!(role_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/roles/:id
  def update
    authorize @project
    @role.update(role_params)
    head :no_content
  end

  # DELETE /projects/:project_id/actors/:id
  def destroy
    authorize @project
    @role.destroy
    head :no_content
  end

  private

  def role_params
    params.permit(:actor_id, :role_level_id)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_role
    @role = @project.roles.find_by!(id: params[:id]) if @project
  end
end
