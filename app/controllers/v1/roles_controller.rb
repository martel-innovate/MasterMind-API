class V1::RolesController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_role
  before_action :set_project_role, only: [:show, :update, :destroy]

  # Swagger specs
  swagger_controller :roles, "Roles Management"

  def self.add_common_params(api)
    api.param :header, 'Authorization', :string, :required, 'Authentication token'
    api.response :unauthorized, "The actor does not have permission to perform this action"
    api.response :unauthorized, "Signature has expired"
    api.response :forbidden, "The provided API token is invalid"
  end

  swagger_api :index do |api|
    V1::RolesController::add_common_params(api)
    summary "Fetches Roles"
    notes "This lists all the Roles belonging to a given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    response :ok, "Success", :Role
  end

  swagger_api :show do |api|
    V1::RolesController::add_common_params(api)
    summary "Fetches a specific Role"
    notes "This fetches the Role matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    response :ok, "Success", :Role
    response :not_found, "Role not found"
  end

  swagger_api :create do |api|
    V1::RolesController::add_common_params(api)
    summary "Register a new Role"
    notes "This registers a new Role in the given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :form, :actor_id, :integer, :required, "Actor Id"
    param :form, :role_level_id, :integer, :required, "Role Level Id"
    param :form, :clusters_permissions, :boolean, :required, "True if the Role alllows an Actor to create, edit or delete. False if only view"
    param :form, :services_permissions, :boolean, :required, "True if the Role alllows an Actor to create, edit or delete. False if only view"
    param :form, :subscriptions_permissions, :boolean, :required, "True if the Role alllows an Actor to create, edit or delete. False if only view"
    response :ok, "Success", :Role
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do |api|
    V1::RolesController::add_common_params(api)
    summary "Updates a Role"
    notes "This updates the Role matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    param :form, :actor_id, :integer, :optional, "Actor Id"
    param :form, :role_level_id, :integer, :optional, "Role Level Id"
    param :form, :clusters_permissions, :boolean, :required, "True if the Role alllows an Actor to create, edit or delete. False if only view"
    param :form, :services_permissions, :boolean, :required, "True if the Role alllows an Actor to create, edit or delete. False if only view"
    param :form, :subscriptions_permissions, :boolean, :required, "True if the Role alllows an Actor to create, edit or delete. False if only view"
    response :ok, "Success", :Role
    response :not_found, "Role not found"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do |api|
    V1::RolesController::add_common_params(api)
    summary "Deletes a Role"
    notes "This deletes the Role matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    response :ok, "Success", :Role
    response :not_found, "Role not found"
  end

  swagger_api :getProjectActorByRole do |api|
    V1::RolesController::add_common_params(api)
    summary "Gets Actor by Role"
    notes "Gets the Actor corresponding to the given Role"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    response :ok, "Success", :Role
    response :not_found, "Actor not found"
  end

  swagger_api :registerRoleByFullname do |api|
    V1::RolesController::add_common_params(api)
    summary "Register Actor Role by Fullname"
    notes "Registers a Role in the given Project for the Actor matching the given Fullname"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Role Id"
    param :form, :fullname, :string, :required, "Actor Fullname"
    response :ok, "Success", :Role
    response :not_found, "Actor not found"
  end

  # GET /projects/:project_id/roles
  def index
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view the roles in this project" }, :unauthorized)
      return
    end
    json_response(@project.roles)
  end

  # GET /projects/:project_id/roles/:id
  def show
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view the roles in this project" }, :unauthorized)
      return
    end
    json_response(@role)
  end

  # POST /projects/:project_id/roles
  def create
    if (@role.nil? or @role_level != 'admin') and !current_actor.superadmin
      json_response({ message: "You don't have permission to create roles for this project" }, :unauthorized)
      return
    end
    @project.roles.create!(role_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/roles/:id
  def update
    if (@role.nil? or @role_level != 'admin') and !current_actor.superadmin
      json_response({ message: "You don't have permission to edit this project's roles" }, :unauthorized)
      return
    end
    @role.update(role_params)
    head :no_content
  end

  # DELETE /projects/:project_id/actors/:id
  def destroy
    if (@role.nil? or @role_level != 'admin') and !current_actor.superadmin
      json_response({ message: "You don't have permission to delete roles for this project" }, :unauthorized)
      return
    end
    @role.destroy
    head :no_content
  end

  # Lists the actors registered in this project.
  def getProjectActorByRole
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view roles for this project" }, :unauthorized)
      return
    end
    r = @project.roles.find(params["role_id"])
    json_response(Actor.find(r.actor_id))
  end

  # Registers a role for an actor within a project, given their fullname
  def registerRoleByFullname
    if (@role.nil? or @role_level != 'admin') and !current_actor.superadmin
      json_response({ message: "You don't have permission to create roles for this project" }, :unauthorized)
      return
    end
    if params["fullname"].nil?
      json_response({ message: "No fullname provided" }, :forbidden)
      return
    end
    actor = Actor.find_by fullname: params["fullname"]
    if actor.nil?
      json_response({ message: "No actor found with that fullname" }, 404)
      return
    end
    @created_role = Role.create(project_id: @project.id, actor_id: actor.id, role_level_id: "2", clusters_permissions: true, services_permissions: true, subscriptions_permissions: true)
    json_response(@created_role, :created)
  end

  private

  # Allowed role params
  def role_params
    params.permit(:actor_id, :role_level_id, :clusters_permissions, :services_permissions, :subscriptions_permissions, :fullname, :role_id)
  end

  # Set project when needed
  def set_project
    @project = Project.find(params[:project_id])
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

  # Set project role when needed
  def set_project_role
    @role = @project.roles.find_by!(id: params[:id]) if @project
  end
end
