class V1::NgsiSubscriptionsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_role
  before_action :set_service, only: [:create]
  before_action :set_subscription, only: [:show, :update, :destroy, :registerSubscription, :deactivateSubscription, :activateSubscription, :removeSubscription]

  # Swagger specs
  swagger_controller :ngsi_subscriptions, "NGSI Subscriptions Management"

  def self.add_common_params(api)
    api.param :header, 'Authorization', :string, :required, 'Authentication token'
    api.response :unauthorized, "The actor does not have permission to perform this action"
    api.response :unauthorized, "Signature has expired"
    api.response :forbidden, "The provided API token is invalid"
  end

  swagger_api :index do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Fetches NSGI Subscriptions"
    notes "This lists all the NGSI Subscriptions belonging to a given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    response :ok, "Success", :NgsiSubscription
  end

  swagger_api :show do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Fetches a specific NSGI Subscription"
    notes "This fetches the NSGI Subscription matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NSGI Subscription Id"
    response :ok, "Success", :NgsiSubscription
    response :not_found, "Subscription not found"
  end

  swagger_api :create do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Register a new NSGI Subscription"
    notes "This registers a new NSGI Subscription in the given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :form, :name, :string, :required, "A name for the NSGI Subscription"
    param :form, :description, :string, :required, "A description for the NSGI Subscription"
    param :form, :throttling, :integer, :required, "The throttling in seconds"
    param :form, :service_id, :integer, :required, "The ID of the service this Subscription belongs to"
    param :form, :subscription_id, :string, :required, "The ID of the Subscription as given by the Context Broker"
    param :form, :subject, :string, :required, "The Subject Object of the Subscription in JSON format"
    param :form, :notification, :string, :required, "The Notification Object of the Subscription in JSON format"
    param :form, :expires, :string, :required, "The expiration date of the Subscription"
    param :form, :status, :string, :required, "The status of the Subscription (e.g. active or inactive)"
    response :ok, "Success", :NgsiSubscription
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Updates a NSGI Subscription"
    notes "This updates the NSGI Subscription matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :form, :name, :string, :optional, "A name for the NSGI Subscription"
    param :form, :description, :string, :optional, "A description for the NSGI Subscription"
    param :form, :throttling, :integer, :optional, "The throttling in seconds"
    param :form, :service_id, :integer, :optional, "The ID of the service this Subscription belongs to"
    param :form, :subscription_id, :string, :optional, "The ID of the Subscription as given by the Context Broker"
    param :form, :subject, :string, :optional, "The Subject Object of the Subscription in JSON format"
    param :form, :notification, :string, :optional, "The Notification Object of the Subscription in JSON format"
    param :form, :expires, :string, :optional, "The expiration date of the Subscription"
    param :form, :status, :string, :optional, "The status of the Subscription (e.g. active or inactive)"
    response :ok, "Success", :NgsiSubscription
    response :not_found, "Subscription not found"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Deletes a Subscription"
    notes "This deletes the Subscription matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Subscription Id"
    response :ok, "Success", :NgsiSubscription
    response :not_found, "Subscription not found"
  end

  swagger_api :registerSubscription do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Registers the Subscription to the Broker"
    notes "This registers this NSGI Subscription to its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
  end

  swagger_api :activateSubscription do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Activates the Subscription on the Broker"
    notes "This activates this already registered NSGI Subscription on its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
  end

  swagger_api :deactivateSubscription do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Deactivates the Subscription on the Broker"
    notes "This deactivates this already registered NSGI Subscription on its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
  end

  swagger_api :removeSubscription do |api|
    V1::NgsiSubscriptionsController::add_common_params(api)
    summary "Removes the Subscription from the Broker"
    notes "This removes this NSGI Subscription from its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
  end

  # GET /projects/:project_id/ngsi_subscriptions
  def index
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view this project's subscriptions" }, :unauthorized)
      return
    end
    json_response(@project.ngsi_subscriptions)
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id
  def show
    if @role.nil? and !current_actor.superadmin
      json_response({ message: "You don't have permission to view this project's subscriptions" }, :unauthorized)
      return
    end
    json_response(@subscription)
  end

  # POST /projects/:project_id/ngsi_subscriptions
  def create
    if (@role.nil? or !(@role.subscriptions_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to create a subscription in this project" }, :unauthorized)
      return
    end
    subscription = @service.ngsi_subscriptions.create!(subscription_params)
    json_response(subscription, :created)
  end

  # PUT /projects/:project_id/ngsi_subscriptions/:id
  def update
    if (@role.nil? or !(@role.subscriptions_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to edit subscriptions in this project" }, :unauthorized)
      return
    end
    @subscription.update(subscription_params)
    head :no_content
  end

  # DELETE /projects/:project_id/ngsi_subscriptions/:id
  def destroy
    if (@role.nil? or !(@role.subscriptions_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to delete subscriptions in this project" }, :unauthorized)
      return
    end
    @subscription.destroy
    head :no_content
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/register
  # Register Subscription to context broker
  def registerSubscription
    require 'json'

    if (@role.nil? or !(@role.subscriptions_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to register subscriptions in this project" }, :unauthorized)
      return
    end

    service_id = @subscription.service_id
    service = Service.find(service_id)

    # Prepare subscription JSON
    subscriptionJSON = {
      'description' => @subscription.description,
      'subject' => JSON.parse(@subscription.subject),
      'notification' => JSON.parse(@subscription.notification),
      'throttling' => @subscription.throttling
    }

    # Add expiration unless is 'never'
    if @subscription.expires != 'never'
      subscriptionJSON["expires"] = @subscription.expires
    end

    # Send it to context broker endpoint for Subscriptions
    # TODO: Move path in configuration elsewhere
    serviceURI = service.endpoint+":1026/v2/subscriptions"

    begin
      response = RestClient.post(
        serviceURI,
        subscriptionJSON.to_json,
        'Content-Type' => 'application/json'
      )
      # Update sub ID if successful and set as active
      subId = URI(response.headers[:location]).path.split('/').last
      @subscription.update(status: "active", subscription_id: subId)
      json_response({subId: subId}, :created)
    rescue RestClient::ExceptionWithResponse => e
      # If error, report to the client
      json_response({message: e.response}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/deactivate
  def deactivateSubscription
    if (@role.nil? or !(@role.subscriptions_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to deactivate subscriptions in this project" }, :unauthorized)
      return
    end
    changeSubscriptionStatus('inactive')
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/activate
  def activateSubscription
    if (@role.nil? or !(@role.subscriptions_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to activate subscriptions in this project" }, :unauthorized)
      return
    end
    changeSubscriptionStatus('active')
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/remove
  # Remove a subscription from the broker
  def removeSubscription
    require 'json'

    if (@role.nil? or !(@role.subscriptions_permissions)) and !current_actor.superadmin
      json_response({ message: "You don't have permission to remove subscriptions in this project" }, :unauthorized)
      return
    end

    sub_id = @subscription.subscription_id
    service_id = @subscription.service_id
    service = Service.find(service_id)

    # Send it to context broker endpoint for Subscriptions
    # TODO: Move path in configuration elsewhere
    serviceURI = service.endpoint+":1026/v2/subscriptions/"+sub_id

    begin
      response = RestClient.delete(serviceURI)
      # Set sub as unregistered and remove ID if successful
      @subscription.update(status: "unregistered", subscription_id: "pending")
      json_response({message: "Subscription removed"})
    rescue RestClient::ExceptionWithResponse => e
      # If errored, report to client
      json_response({message: e.response}, :unprocessable_entity)
    end
  end

  private

  # Allowed params for subs
  def subscription_params
    params.permit(:project_id, :service_id, :subscription_id, :name, :description, :subject, :notification, :expires, :throttling, :status)
  end

  # Set sub if needed
  def set_subscription
    @subscription = NgsiSubscription.find(params[:id]) if @project
  end

  # Set project if needed
  def set_project
    @project = Project.find(params[:project_id])
  end

  # Set role if needed
  def set_role
    @role = Role.find_by_actor_id_and_project_id(current_actor.id, @project.id)
  end

  # Set service if needed
  def set_service
    @service = Service.find(params[:service_id])
  end

  # Switch sub status to active or inactive
  def changeSubscriptionStatus(status)
    require 'json'

    sub_id = @subscription.subscription_id
    service_id = @subscription.service_id
    service = Service.find(service_id)

    # Only change sub status
    subscriptionJSON = {
      'status' => status
    }.to_json

    # Send it to context broker endpoint for Subscriptions
    # TODO: Move path in configuration elsewhere
    serviceURI = service.endpoint+":1026/v2/subscriptions/"+sub_id

    begin
      response = RestClient.patch(
        serviceURI,
        subscriptionJSON,
        'Content-Type' => 'application/json'
      )
      # Change status of sub if successful
      @subscription.update(status: status)
      json_response({status: status})
    rescue RestClient::ExceptionWithResponse => e
      # If errored, report to client
      json_response({message: e.response}, :unprocessable_entity)
    end
  end
end
