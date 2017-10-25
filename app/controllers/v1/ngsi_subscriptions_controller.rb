class V1::NgsiSubscriptionsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_service, only: [:create]
  before_action :set_subscription, only: [:show, :update, :destroy, :registerSubscription, :deactivateSubscription, :activateSubscription, :removeSubscription]

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

  def deactivateSubscription
    changeSubscriptionStatus('inactive')
  end

  def activateSubscription
    changeSubscriptionStatus('active')
  end

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
