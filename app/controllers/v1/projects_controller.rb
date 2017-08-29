class V1::ProjectsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all
    json_response(@projects)
  end

  # POST /projects
  def create
    @project = Project.create!(project_params)
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
