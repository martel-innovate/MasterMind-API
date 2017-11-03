class V1::NgsiSubscriptionsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_service, only: [:create]
  before_action :set_subscription, only: [:show, :update, :destroy, :registerSubscription, :deactivateSubscription, :activateSubscription, :removeSubscription]

  swagger_controller :ngsi_subscriptions, "NGSI Subscriptions Management"

  swagger_api :index do
    summary "Fetches NSGI Subscriptions"
    notes "This lists all the NGSI Subscriptions belonging to a given Project"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    response :ok, "Success", :NgsiSubscription
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :show do
    summary "Fetches a specific NSGI Subscription"
    notes "This fetches the NSGI Subscription matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NSGI Subscription Id"
    response :ok, "Success", :NgsiSubscription
    response :not_found, "Subscription not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :create do
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
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do
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
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do
    summary "Deletes a Subscription"
    notes "This deletes the Subscription matching the given id"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :id, :integer, :required, "Subscription Id"
    response :ok, "Success", :NgsiSubscription
    response :not_found, "Subscription not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :registerSubscription do
    summary "Registers the Subscription to the Broker"
    notes "This registers this NSGI Subscription to its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :activateSubscription do
    summary "Activates the Subscription on the Broker"
    notes "This activates this already registered NSGI Subscription on its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :deactivateSubscription do
    summary "Deactivates the Subscription on the Broker"
    notes "This deactivates this already registered NSGI Subscription on its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :removeSubscription do
    summary "Removes the Subscription from the Broker"
    notes "This removes this NSGI Subscription from its associated Context Broker"
    param :header, 'Authorization', :string, :required, 'Authentication token'
    param :path, :project_id, :integer, :required, "Project Id"
    param :path, :id, :integer, :required, "NGSI Subscription Id"
    response :ok, "Success"
    response :not_found, "NGSI Subscription not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  # GET /projects/:project_id/ngsi_subscriptions
  def index
    authorize @project
    if params[:service_id] then
      json_response(Service.find(params[:service_id]).ngsi_subscriptions)
    else
      json_response(NgsiSubscription.all)
    end
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id
  def show
    authorize @project
    json_response(@subscription)
  end

  # POST /projects/:project_id/ngsi_subscriptions
  def create
    authorize @project
    subscription = @service.ngsi_subscriptions.create!(subscription_params)
    json_response(subscription, :created)
  end

  # PUT /projects/:project_id/ngsi_subscriptions/:id
  def update
    authorize @project
    @subscription.update(subscription_params)
    head :no_content
  end

  # DELETE /projects/:project_id/ngsi_subscriptions/:id
  def destroy
    authorize @project
    @subscription.destroy
    head :no_content
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/register
  def registerSubscription
    require 'json'

    service_id = @subscription.service_id
    service = Service.find(service_id)

    subscriptionJSON = {
      'description' => @subscription.description,
      'subject' => JSON.parse(@subscription.subject),
      'notification' => JSON.parse(@subscription.notification),
      'expires' => @subscription.expires,
      'throttling' => @subscription.throttling
    }.to_json

    serviceURI = service.endpoint+":1026/v2/subscriptions"

    begin
      response = RestClient.post(
        serviceURI,
        subscriptionJSON,
        'Content-Type' => 'application/json'
      )
      subId = URI(response.headers[:location]).path.split('/').last
      @subscription.update(status: "active", subscription_id: subId)
      json_response({subId: subId}, :created)
    rescue RestClient::ExceptionWithResponse => e
      json_response({message: e.response}, :unprocessable_entity)
    end
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/deactivate
  def deactivateSubscription
    changeSubscriptionStatus('inactive')
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/activate
  def activateSubscription
    changeSubscriptionStatus('active')
  end

  # GET /projects/:project_id/ngsi_subscriptions/:id/remove
  def removeSubscription
    require 'json'

    sub_id = @subscription.subscription_id
    service_id = @subscription.service_id
    service = Service.find(service_id)

    serviceURI = service.endpoint+":1026/v2/subscriptions/"+sub_id

    begin
      response = RestClient.delete(serviceURI)
      @subscription.update(status: "unregistered", subscription_id: "pending")
      json_response({message: "Subscription removed"})
    rescue RestClient::ExceptionWithResponse => e
      json_response({message: e.response}, :unprocessable_entity)
    end
  end

  private

  def subscription_params
    params.permit(:service_id, :subscription_id, :name, :description, :subject, :notification, :expires, :throttling, :status)
  end

  def set_subscription
    @subscription = NgsiSubscription.find(params[:id]) if @project
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_service
    @service = Service.find(params[:service_id])
  end

  def changeSubscriptionStatus(status)
    require 'json'

    sub_id = @subscription.subscription_id
    service_id = @subscription.service_id
    service = Service.find(service_id)

    subscriptionJSON = {
      'status' => status
    }.to_json

    serviceURI = service.endpoint+":1026/v2/subscriptions/"+sub_id

    puts serviceURI

    begin
      response = RestClient.patch(
        serviceURI,
        subscriptionJSON,
        'Content-Type' => 'application/json'
      )
      @subscription.update(status: status)
      json_response({status: status})
    rescue RestClient::ExceptionWithResponse => e
      json_response({message: e.response}, :unprocessable_entity)
    end
  end
end
