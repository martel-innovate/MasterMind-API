class V1::ClustersController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_project_cluster, only: [:show, :update, :destroy, :info, :version, :deploy]

  # GET /projects/:project_id/clusters
  def index
    authorize @project
    json_response(@project.clusters)
  end

  # GET /projects/:project_id/clusters/:id
  def show
    authorize @project
    json_response(@cluster)
  end

  # POST /projects/:project_id/clusters
  def create
    authorize @project
    @project.clusters.create!(cluster_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/clusters/:id
  def update
    authorize @project
    @cluster.update(cluster_params)
    head :no_content
  end

  # DELETE /projects/:project_id/clusters/:id
  def destroy
    authorize @project
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

  # GET /projects/:project_id/clusters/:id/deploy
  def deploy
    require 'rest_client'

    serviceName = "Mongo"
    service = Service.find(params["service_id"])
    if service.nil? then
      return
    end

    serviceType = ServiceType.find(service.service_type_id)
    serviceTypeName = serviceType.name
    composeData = serviceType.deploy_template

    envVariables = ""

    begin
      serviceConf = JSON.parse(service.configuration)
      serviceConf.each do |k, v|
        envVariables = envVariables + k + ": " + v.to_s + "\n"
      end
    rescue JSON::ParserError
      json_response({message: "Invalid configuration"}, :unprocessable_entity)
      return
    end

    envVariables = envVariables.chomp("\n")

    stack = {
      'name' => serviceName,
      'engine-url' => @cluster.endpoint,
      'compose-file' => composeData,
      'compose-vars' => envVariables,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    begin
      response = RestClient.post(
        'http://localhost:8081/v1/stack',
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + result
      json_response(response, :created)
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
      json_response({message: e.response}, :unprocessable_entity)
    end
  end

  def deployWithDockerClient
    service = Service.find(params["service_id"])
    if service.nil? then
      return
    end

    envVariables = ""

    begin
      serviceConf = JSON.parse(service.configuration)
      serviceConf.each do |k, v|
        envVariables = envVariables + k + "=" + v + " "
      end
    rescue JSON::ParserError
      json_response({status: "Invalid configuration"}, :unprocessable_entity)
    end

    tempdir = set_tls_certs_dir()

    serviceTypeName = ServiceType.find(service.service_type_id).name
    cmd = envVariables + "DOCKER_TLS_VERIFY=1 DOCKER_HOST=#{@cluster.endpoint} DOCKER_CERT_PATH=#{tempdir} docker stack deploy --compose-file ./mastermind-services/" + serviceTypeName + "/docker-compose.yml " + ServiceType.find(service.service_type_id).name
    status = `#{cmd}`

    remove_tls_certs_dir(tempdir)
    service.update({endpoint: @cluster.endpoint, status: "Active", docker_service_id: serviceTypeName})
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

    cert = File.new(File.join(tempdir, "cert.pem"), "w+")
    cert.puts(@cluster.cert.gsub("\\n", "\n"))
    cert.close

    key = File.new(File.join(tempdir, "/key.pem"), "w+")
    key.puts(@cluster.key.gsub("\\n", "\n"))
    key.close

    ca = File.new(File.join(tempdir, "/ca.pem"), "w+")
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
