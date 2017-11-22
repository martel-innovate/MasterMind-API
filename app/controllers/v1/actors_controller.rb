class V1::ActorsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :check_if_superadmin
  before_action :set_actor, only: [:show, :update, :destroy]

  swagger_controller :actors, "Actors Management"

  def self.add_common_params(api)
    api.response :unauthorized, "The actor does not have permission to perform this action"
    api.response :invalid_token, "The provided API token is invalid"
    api.response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :index do |api|
    V1::ActorsController::add_common_params(api)
    summary "Fetches all Actors"
    notes "This lists all the active actors"
    response :ok, "Success", :Actor
  end

  swagger_api :show do |api|
    V1::ActorsController::add_common_params(api)
    summary "Fetches a specific Actor"
    notes "This fetches the Actor matching the given id"
    param :path, :id, :integer, :required, "Actor Id"
    response :ok, "Success", :Actor
    response :not_found, "Actor not found"
  end

  swagger_api :create do |api|
    V1::ActorsController::add_common_params(api)
    summary "Creates an Actor"
    notes "This creates a new Actor"
    param :form, :fullname, :string, :required, "The full name of the actor"
    param :form, :email, :string, :required, "The Actor's email address"
    response :ok, "Success", :Actor
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do |api|
    V1::ActorsController::add_common_params(api)
    summary "Updates an Actor"
    notes "This updates the Actor matching the given id"
    param :path, :id, :integer, :required, "Actor Id"
    param :form, :fullname, :string, :optional, "The full name of the actor"
    param :form, :email, :string, :optional, "The Actor's email address"
    response :ok, "Success", :Actor
    response :not_found, "Actor not found"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do |api|
    V1::ActorsController::add_common_params(api)
    summary "Deletes an Actor"
    notes "This deletes the Actor matching the given id"
    response :ok, "Success", :Actor
    param :path, :id, :integer, :required, "Actor Id"
    response :not_found, "Actor not found"
  end

  # GET /actors
  def index
    @actors = Actor.all
    json_response(@actors)
  end

  # GET /actors/:id
  def show
    json_response(@actor)
  end

  # POST /actors
  def create
    @actor = Actor.create!(actor_params)
    json_response(@actor, :created)
  end

  # PUT /actors/:id
  def update
    @actor.update(actor_params)
    head :no_content
  end

  # DELETE /actors/:id
  def destroy
    @actor.destroy
    head :no_content
  end

  private

  def actor_params
    params.permit(:email, :fullname, :superadmin)
  end

  def check_if_superadmin
    if !current_user().superadmin
      json_response({ message: "Not authorized" }, :unauthorized)
      return
    end
  end

  def set_actor
    @actor = Actor.find(params[:id])
  end
end
