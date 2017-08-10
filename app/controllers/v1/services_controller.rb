class V1::ServicesController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_project
  before_action :set_service, only: [:show, :update, :destroy]

  # GET /projects/:project_id/services
  def index
    json_response(@project.services)
  end

  # GET /projects/:project_id/services/:id
  def show
    json_response(@service)
  end

  # POST /projects/:project_id/services
  def create
    @project.services.create!(service_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/services/:id
  def update
    @service.update(service_params)
    head :no_content
  end

  # DELETE /projects/:project_id/services/:id
  def destroy
    @service.destroy
    head :no_content
  end

  private

  def service_params
    params.permit(:configuration, :status, :managed, :endpoint,
    :docker_service_id, :latitude, :longitude, :service_type_id)
  end

  def set_service
    @service = Service.find(params[:id]) if @project
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

end
