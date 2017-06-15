class V1::RolesController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_project
  before_action :set_project_role, only: [:show, :update, :destroy]

  # GET /projects/:project_id/roles
  def index
    json_response(@project.roles)
  end

  # GET /projects/:project_id/roles/:id
  def show
    json_response(@role)
  end

  # POST /projects/:project_id/roles
  def create
    @project.roles.create!(role_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/roles/:id
  def update
    @role.update(actor_params)
    head :no_content
  end

  # DELETE /projects/:project_id/actors/:id
  def destroy
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
