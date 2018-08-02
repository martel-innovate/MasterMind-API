class V1::ClustersController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_role
  before_action :set_project_cluster, only: [:show, :update, :destroy, :info, :version,
    :deploy, :deployWithDockerClient, :getNetworks, :createNetwork, :getVolumes, :createVolume, :getStack, :removeStack]

  # Swagger specs
  swagger_controller :clusters, "Cluster Management"

  def self.add_common_params(api)
    api.response :unauthorized, "The actor does not have permission to perform this action"
    api.response :invalid_token, "The provided API token is invalid"
    api.response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :index do |api|
    V1::ClustersController::add_common_params(api)
    summary "Fetches Clusters"
    notes "This lists all the Clusters belonging to a given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    response :ok, "Success", :Cluster
  end

  swagger_api :show do |api|
    V1::ClustersController::add_common_params(api)
    summary "Fetches a specific Cluster"
    notes "This fetches the Cluster matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Cluster Id"
    response :ok, "Success", :Actor
    response :not_found, "Cluster not found"
  end

  swagger_api :create do |api|
    V1::ClustersController::add_common_params(api)
    summary "Register a new Cluster"
    notes "This registers a new Cluster in the given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :form, :name, :string, :required, "A name for the Cluster"
    param :form, :description, :string, :required, "A description for the Cluster"
    param :form, :endpoint, :string, :required, "The Cluster's endpoint"
    param :form, :cert, :string, :required, "The cert certificate for TLS"
    param :form, :ca, :string, :required, "The ca certificate for TLS"
    param :form, :key, :string, :required, "The key for TLS"
    response :ok, "Success", :Actor
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do |api|
    V1::ClustersController::add_common_params(api)
    summary "Updates a Cluster"
    notes "This updates the Cluster matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Cluster Id"
    param :form, :name, :string, :required, "A name for the Cluster"
    param :form, :description, :string, :required, "A description for the Cluster"
    param :form, :endpoint, :string, :required, "The Cluster's endpoint"
    param :form, :cert, :string, :required, "The cert certificate for TLS"
    param :form, :ca, :string, :required, "The ca certificate for TLS"
    param :form, :key, :string, :required, "The key for TLS"
    response :ok, "Success", :Actor
    response :not_found, "Cluster not found"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do |api|
    V1::ClustersController::add_common_params(api)
    summary "Deletes a Cluster"
    notes "This deletes the Cluster matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Cluster Id"
    response :ok, "Success", :Actor
    response :not_found, "Cluster not found"
  end

  swagger_api :deploy do |api|
    V1::ClustersController::add_common_params(api)
    summary "Deploys the Service"
    notes "This deploys the Service on its associated Docker Swarm Cluster"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Cluster Id"
    param :query, :service_id, :string, :required, "ID of the Service to deploy"
    param :query, :service_name, :string, :required, "Name of the Service to deploy"
    response :ok, "Success"
    response :not_found, "Service not found"
  end

  swagger_api :getStack do |api|
    V1::ClustersController::add_common_params(api)
    summary "Gets info on the Service from Docker"
    notes "This retrieves info on the Service (defined as a Docker Stack) from Docker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Cluster Id"
    param :query, :service_name, :string, :required, "Name of the Service"
    response :ok, "Success"
    response :not_found, "Service not found"
  end

  swagger_api :removeStack do |api|
    V1::ClustersController::add_common_params(api)
    summary "Removes the Service from Docker"
    notes "This undeploys the Service from its associated Docker Swarm Cluster"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "Cluster Id"
    param :query, :service_name, :string, :required, "Name of the Service to remove"
    response :ok, "Success"
    response :not_found, "Service not found"
  end

  # GET /projects/:project_id/clusters
  def index
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view the clusters in this project" }, :unauthorized)
      return
    end
    json_response(@project.clusters)
  end

  # GET /projects/:project_id/clusters/:id
  def show
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view the clusters in this project" }, :unauthorized)
      return
    end
    json_response(@cluster)
  end

  # POST /projects/:project_id/clusters
  def create
    if (@role.nil? or !(@role.clusters_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to create a cluster in this project" }, :unauthorized)
      return
    end
    @project.clusters.create!(cluster_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/clusters/:id
  def update
    if (@role.nil? or !(@role.clusters_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to edit clusters in this project" }, :unauthorized)
      return
    end
    @cluster.update(cluster_params)
    head :no_content
  end

  # DELETE /projects/:project_id/clusters/:id
  def destroy
    if (@role.nil? or !(@role.clusters_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to delete clusters in this project" }, :unauthorized)
      return
    end
    @cluster.destroy
    head :no_content
  end

  # GET /projects/:project_id/clusters/:id/getnetworks
  # Retrieve networks of a given cluster
  def getNetworks
    require 'rest_client'
    require 'uri'

    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view networks" }, :unauthorized)
      return
    end

    # Env variables for Manager host and port
    serviceManagerHost = Settings.service_manager_host
    serviceManagerPort = Settings.service_manager_port.to_s
    serviceManagerURI = 'http://'+serviceManagerHost+':'+serviceManagerPort+'/v1/network'

    # Create request for Service Manager
    stack = {
      'engine-url' => @cluster.endpoint,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    begin
      response = RestClient.post(
        serviceManagerURI,
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + response
      json_response(response, 200)
    rescue Exception => e
      # If error, respond with it
      puts e
      json_response({message: e}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/clusters/:id/getvolumes
  # Retrieve volumes of a given cluster
  def getVolumes
    require 'rest_client'
    require 'uri'

    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view volumes" }, :unauthorized)
      return
    end

    # Env variables for Manager host and port
    serviceManagerHost = Settings.service_manager_host
    serviceManagerPort = Settings.service_manager_port.to_s
    serviceManagerURI = 'http://'+serviceManagerHost+':'+serviceManagerPort+'/v1/volume'

    # Create request for Service Manager
    stack = {
      'engine-url' => @cluster.endpoint,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    begin
      response = RestClient.post(
        serviceManagerURI,
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + response
      json_response(response, 200)
    rescue Exception => e
      # If error, respond with it
      puts e
      json_response({message: e}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/clusters/:id/createnetwork
  # Retrieve networks of a given stack
  def createNetwork
    require 'rest_client'
    require 'uri'

    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to create networks" }, :unauthorized)
      return
    end

    # Service name in the query
    networkName = params["network_name"]

    # Env variables for Manager host and port
    serviceManagerHost = Settings.service_manager_host
    serviceManagerPort = Settings.service_manager_port.to_s
    serviceManagerURI = 'http://'+serviceManagerHost+':'+serviceManagerPort+'/v1/network'

    # Create request for Service Manager
    stack = {
      'name' => networkName,
      'engine-url' => @cluster.endpoint,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    begin
      response = RestClient.post(
        serviceManagerURI,
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + response
      json_response(response, :created)
    rescue Exception => e
      # If error, respond with it
      puts e
      json_response({message: e}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/clusters/:id/createvolume
  # Retrieve networks of a given stack
  def createVolume
    require 'rest_client'
    require 'uri'

    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view the clusters in this project" }, :unauthorized)
      return
    end

    # Service name in the query
    volumeName = params["volume_name"]

    # Env variables for Manager host and port
    serviceManagerHost = Settings.service_manager_host
    serviceManagerPort = Settings.service_manager_port.to_s
    serviceManagerURI = 'http://'+serviceManagerHost+':'+serviceManagerPort+'/v1/volume'

    # Create request for Service Manager
    stack = {
      'name' => volumeName,
      'engine-url' => @cluster.endpoint,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    begin
      response = RestClient.post(
        serviceManagerURI,
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + response
      json_response(response, :created)
    rescue Exception => e
      # If error, respond with it
      puts e
      json_response({message: e}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/clusters/:id/getstack
  # Retrieve informations about a given stack
  def getStack
    require 'rest_client'
    require 'uri'

    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view the clusters in this project" }, :unauthorized)
      return
    end

    # Service name in the query
    serviceName = params["service_name"]
    # Env variables for Manager host and port
    serviceManagerHost = Settings.service_manager_host
    serviceManagerPort = Settings.service_manager_port.to_s
    serviceManagerURI = 'http://'+serviceManagerHost+':'+serviceManagerPort+'/v1/stack/'+serviceName

    # Create request for Service Manager
    stack = {
      'name' => serviceName,
      'engine-url' => @cluster.endpoint,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    begin
      response = RestClient.post(
        serviceManagerURI,
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + response
      json_response(response, :created)
    rescue Exception => e
      # If error, respond with it
      puts e
      json_response({message: e}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/clusters/:id/removeStack
  # Remove the given stack from the cluster
  def removeStack
    require 'rest_client'
    require 'uri'

    if (@role.nil? or !(@role.services_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to undeploy services in this project" }, :unauthorized)
      return
    end

    # Service name in query
    serviceName = params["service_name"]
    service = Service.find(params["service_id"])
    if service.nil? then
      return
    end

    # Env variables for Manager host and port
    serviceManagerHost = Settings.service_manager_host
    serviceManagerPort = Settings.service_manager_port.to_s
    serviceManagerURI = 'http://'+serviceManagerHost+':'+serviceManagerPort+'/v1/stack/delete/'+serviceName

    # Create request for Service Manager
    stack = {
      'name' => serviceName,
      'engine-url' => @cluster.endpoint,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    puts stack

    begin
      response = RestClient.post(
        serviceManagerURI,
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + response
      # Update Service to inactive status
      # TODO: Perhaps make a better check
      service.update({endpoint: "Not Deployed", status: "Inactive", docker_service_id: "Not Deployed"})
      json_response(response, :created)
    rescue Exception => e
      # If error, send it as response
      puts e
      json_response({message: e}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/clusters/:id/deploy
  # Deploys a stack on the cluster
  def deploy
    require 'rest_client'
    require 'uri'

    if (@role.nil? or !(@role.services_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to deploy services in this project" }, :unauthorized)
      return
    end

    # Env variables for Manager host and port
    serviceManagerHost = Settings.service_manager_host
    serviceManagerPort = Settings.service_manager_port.to_s
    serviceManagerURI = 'http://'+serviceManagerHost+':'+serviceManagerPort+'/v1/stack'

    # Service name in query
    serviceName = params["service_name"]
    service = Service.find(params["service_id"])
    if service.nil? then
      return
    end

    # Find Service type to retrieve deploy template
    serviceType = ServiceType.find(service.service_type_id)
    serviceTypeName = serviceType.name
    serviceTypeVersion = serviceType.version
    composeData = serviceType.deploy_template

    # Getting external files needed by the compose
    externalFiles = []
    for path in Dir['./'+serviceType.local_path+'/*']
      externalFileName = File.basename(path)
      if (externalFileName != "docker-compose.yml" && externalFileName != "mastermind.yml")
        externalFileContents = File.read(path)
        externalFiles.append({"#{externalFileName}" => externalFileContents})
      end
    end

    # Making env variable string for Service Manager (YAML format)
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

    # Preparing message for Service Manager
    stack = {
      'name' => serviceName,
      'engine-url' => @cluster.endpoint,
      'compose-file' => composeData,
      'compose-vars' => envVariables,
      'external_files' => externalFiles,
      'ca-cert' => @cluster.ca,
      'cert' => @cluster.cert,
      'cert-key' => @cluster.key
    }.to_json

    begin
      response = RestClient.post(
        serviceManagerURI,
        stack,
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      )
      puts "Deploy Response: " + response
      json_response(response, :created)
      # Update service as Active if successfully deployed
      # TODO: Perhaps make a better check
      service.update({endpoint: URI.parse(@cluster.endpoint).host, status: "Active", docker_service_id: serviceName})
    rescue Exception => e
      # If error, return it to the client
      puts e
      json_response({message: e}, :unprocessable_entity)
    end
  end

  private

  # Allowed params for cluster
  def cluster_params
    params.permit(:name, :description, :endpoint, :cert, :key, :ca)
  end

  # Set project if needed
  def set_project
    @project = Project.find(params[:project_id])
  end

  # Set role if needed
  def set_role
    @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
  end

  # Set specific cluster if needed
  def set_project_cluster
    @cluster = @project.clusters.find_by!(id: params[:id]) if @project
  end
end
