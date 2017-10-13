class V1::NgsiSubscriptionsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_service, only: [:create]
  before_action :set_subscription, only: [:show, :update, :destroy, :registerSubscriptionToBroker]

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

  def registerSubscriptionToBroker
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

    begin
      response = RestClient.post(
        service.endpoint+":1026/v2/subscriptions",
        subscriptionJSON,
        'Content-Type' => 'application/json'
      )
      subId = URI(response.headers[:location]).path.split('/').last
      @subscription.update(status: "Active", subscription_id: subId)
      json_response({subId: subId}, :created)
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
end
