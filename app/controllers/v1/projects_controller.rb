class V1::ProjectsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project, only: [:show, :update, :destroy]

  swagger_controller :projects, "Project Management"

  swagger_api :index do
    summary "Fetches Projects"
    notes "This lists all the Projects"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    response :ok, "Success", :Project
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :show do
    summary "Fetches a specific Project"
    notes "This fetches the Project matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Project Id"
    response :ok, "Success", :Project
    response :not_found, "Project not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :create do
    summary "Register a new Project"
    notes "This registers a new Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :form, :name, :string, :required, "A name for the Project"
    param :form, :description, :string, :required, "A description for the Project"
    response :ok, "Success", :Project
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do
    summary "Updates a Project"
    notes "This updates the Project matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Project Id"
    param :form, :name, :string, :optional, "A name for the NSGI Subscription"
    param :form, :description, :string, :optional, "A description for the NSGI Subscription"
    response :ok, "Success", :Project
    response :not_found, "Project not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do
    summary "Deletes a Project"
    notes "This deletes the Project matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Project Id"
    response :ok, "Success", :Project
    response :not_found, "Project not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  # GET /projects
  def index
    @projects = Project.all
    json_response(@projects)
  end

  # POST /projects
  def create
    @project = Project.create!(project_params)
    @role = Role.create(project_id: @project.id, actor_id: current_actor.id, role_level_id: "1")
    json_response(@project, :created)
  end

  # GET /projects/:id
  def show
    authorize @project
    json_response(@project)
  end

  # PUT /projects/:id
  def update
    authorize @project
    @project.update(project_params)
    head :no_content
  end

  # DELETE /projects/:id
  def destroy
    authorize @project
    @project.destroy
    head :no_content
  end

  private

  def project_params
    # whitelist params
    params.permit(:name, :description)
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
