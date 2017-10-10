class NgsiSubscriptionsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :set_project
  before_action :set_service
  before_action :set_subscription, only: [:show, :update, :destroy]

  # GET /projects/:project_id/services
  def index
    authorize @project
    json_response(@service.ngsi_subscriptions)
  end

  # GET /projects/:project_id/services/:id
  def show
    authorize @project
    json_response(@subscription)
  end

  # POST /projects/:project_id/services
  def create
    authorize @project
    subscription = @service.ngsi_subscriptions.create!(subscription_params)
    json_response(subscription, :created)
  end

  # PUT /projects/:project_id/services/:id
  def update
    authorize @project
    @subscription.update(subscription_params)
    head :no_content
  end

  # DELETE /projects/:project_id/services/:id
  def destroy
    authorize @project
    @subscription.destroy
    head :no_content
  end

  private

  def subscription_params
    params.permit(:name, :entities, :attr, :reference, :duration, :notifyConditions, :throttling)
  end

  def set_subscription
    @subscription = NgsiSubscription.find(params[:id]) if @service
  end

  def set_service
    @service = Service.find(params[:service_id]) if @project
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
