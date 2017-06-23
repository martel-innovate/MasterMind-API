class V1::ClustersController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_project
  before_action :set_project_cluster, only: [:show, :update, :destroy, :info, :version]

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

  # GET /projects/:project_id/clusters/:id/info
  def info
    tempdir = set_tls_certs_dir()

    status = `DOCKER_TLS_VERIFY="1" DOCKER_HOST=#{@cluster.endpoint} DOCKER_CERT_PATH=#{tempdir} docker info`

    remove_tls_certs_dir(tempdir)
    json_response({status: status})
  end

  # GET /projects/:project_id/clusters/:id/version
  def version
    tempdir = set_tls_certs_dir()

    status = `DOCKER_TLS_VERIFY="1" DOCKER_HOST=#{@cluster.endpoint} DOCKER_CERT_PATH=#{tempdir} docker version`

    remove_tls_certs_dir(tempdir)
    json_response({status: status})
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

  def set_tls_certs_dir()
    tempdir = Dir.mktmpdir()

    cert = File.new(tempdir+"/cert.pem", "w+")
    cert.puts(@cluster.cert.gsub("\\n", "\n"))
    cert.close

    key = File.new(tempdir+"/key.pem", "w+")
    key.puts(@cluster.key.gsub("\\n", "\n"))
    key.close

    ca = File.new(tempdir+"/ca.pem", "w+")
    ca.puts(@cluster.ca.gsub("\\n", "\n"))
    ca.close

    return tempdir
  end

  def remove_tls_certs_dir(tempdir)
    FileUtils.remove_entry_secure(tempdir+"/cert.pem")
    FileUtils.remove_entry_secure(tempdir+"/key.pem")
    FileUtils.remove_entry_secure(tempdir+"/ca.pem")
    FileUtils.remove_entry_secure(tempdir)
  end

end
