class V1::ActorsController < ApplicationController
  #skip_before_action :authorize_request
  before_action :check_if_superadmin, only: [:index, :create, :update, :destroy]
  before_action :set_actor, only: [:show, :update, :destroy]

  # Swagger specs
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
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to view the actors" }, :forbidden)
      return
    end
    @actors = Actor.all
    json_response(@actors)
  end

  # GET /actors/:id
  def show
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to view the actors" }, :forbidden)
      return
    end
    json_response(@actor)
  end

  # POST /actors
  def create
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to create actors" }, :forbidden)
      return
    end
    @actor = Actor.create!(actor_params)
    json_response(@actor, :created)
  end

  # PUT /actors/:id
  def update
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to edit actors" }, :forbidden)
      return
    end
    @actor.update(actor_params)
    head :no_content
  end

  # DELETE /actors/:id
  def destroy
    if !current_actor.superadmin
      json_response({ message: "You don't have permission to delete actors" }, :forbidden)
      return
    end
    @actor.destroy
    head :no_content
  end

  private

  # Permitted params
  def actor_params
    params.permit(:email, :fullname, :superadmin)
  end

  # Check if current user is superadmin (can alter actors)
  def check_if_superadmin
    if !current_user().superadmin
      json_response({ message: "Not authorized" }, :unauthorized)
      return
    end
  end

  # Set actor for actions on specific actor
  def set_actor
    @actor = Actor.find(params[:id])
  end
end
