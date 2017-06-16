class V1::ClustersController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_project
  before_action :set_project_cluster, only: [:show, :update, :destroy]

  # GET /projects/:project_id/clusters
  def index
    json_response(@project.clusters)
  end

  # GET /projects/:project_id/clusters/:id
  def show
    json_response(@cluster)
  end

  # POST /projects/:project_id/clusters
  def create
    @project.clusters.create!(cluster_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/clusters/:id
  def update
    @cluster.update(cluster_params)
    head :no_content
  end

  # DELETE /projects/:project_id/clusters/:id
  def destroy
    @cluster.destroy
    head :no_content
  end

  private

  def cluster_params
    params.permit(:name, :description, :endpoint, :cert, :key, :ca)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_cluster
    @cluster = @project.clusters.find_by!(id: params[:id]) if @project
  end
end
