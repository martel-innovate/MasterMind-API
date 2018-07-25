class V1::ProjectsController < ApplicationController
  #skip_before_action :authorize_request, only: :index
  before_action :set_project, only: [:show, :update, :destroy]
  before_action :set_role, only: [:show, :update, :destroy]

  # Swagger specs
  swagger_controller :projects, "Project Management"

  def self.add_common_params(api)
    api.response :unauthorized, "The actor does not have permission to perform this action"
    api.response :invalid_token, "The provided API token is invalid"
    api.response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :index do |api|
    V1::ProjectsController::add_common_params(api)
    summary "Fetches Projects"
    notes "This lists all the Projects"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    response :ok, "Success", :Project
  end

  swagger_api :show do |api|
    V1::ProjectsController::add_common_params(api)
    summary "Fetches a specific Project"
    notes "This fetches the Project matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Project Id"
    response :ok, "Success", :Project
    response :not_found, "Project not found"
  end

  swagger_api :create do |api|
    V1::ProjectsController::add_common_params(api)
    summary "Register a new Project"
    notes "This registers a new Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :form, :name, :string, :required, "A name for the Project"
    param :form, :description, :string, :required, "A description for the Project"
    response :ok, "Success", :Project
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do |api|
    V1::ProjectsController::add_common_params(api)
    summary "Updates a Project"
    notes "This updates the Project matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Project Id"
    param :form, :name, :string, :optional, "A name for the NSGI Subscription"
    param :form, :description, :string, :optional, "A description for the NSGI Subscription"
    response :ok, "Success", :Project
    response :not_found, "Project not found"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do |api|
    V1::ProjectsController::add_common_params(api)
    summary "Deletes a Project"
    notes "This deletes the Project matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Project Id"
    response :ok, "Success", :Project
    response :not_found, "Project not found"
  end

  # GET /projects
  def index
    @projects = Project.all
    @filteredProjects = []
    @projects.each do |project|
      role = Role.find_by_actor_id_and_project_id(current_actor.id, project.id)
      if !role.nil? or current_actor.superadmin
        @filteredProjects.push(project)
      end
    end
    json_response(@filteredProjects)
  end

  # POST /projects
  def create
    @project = Project.create!(project_params)
    @role = Role.create(project_id: @project.id, actor_id: current_actor.id, role_level_id: "1", clusters_permissions: true, services_permissions: true, subscriptions_permissions: true)
    json_response(@project, :created)
  end

  # GET /projects/:id
  def show
    if @role.nil?
      json_response({ message: "You don't have permission to view this project" }, :forbidden)
      return
    end
    json_response(@project)
  end

  # PUT /projects/:id
  def update
    if @role.nil? or @role_level != 'admin'
      json_response({ message: "You don't have permission to edit this project" }, :forbidden)
      return
    end
    @project.update(project_params)
    head :no_content
  end

  # DELETE /projects/:id
  def destroy
    if @role.nil? or @role_level != 'admin'
      json_response({ message: "You don't have permission to delete this project" }, :forbidden)
      return
    end
    @project.destroy
    head :no_content
  end

  private

  # Allowed project params
  def project_params
    # whitelist params
    params.permit(:name, :description)
  end

  # Set project if needed
  def set_project
    @project = Project.find(params[:id])
  end

  # Set role if needed
  def set_role
    @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
    if @role
      @role_level = (RoleLevel.find(@role.role_level_id)).name
    else
      @role_level = ''
    end
  end
end
