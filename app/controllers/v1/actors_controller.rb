class V1::ActorsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_actor, only: [:show, :update, :destroy]

  swagger_controller :actors, "Actors Management"

  swagger_api :index do
    summary "Fetches all Actors"
    notes "This lists all the active actors"
    response :ok, "Success", :Actor
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :show do
    summary "Fetches a specific Actor"
    notes "This fetches the Actor matching the given id"
    param :path, :id, :integer, :required, "Actor Id"
    response :ok, "Success", :Actor
    response :not_found, "Actor not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :create do
    summary "Creates an Actor"
    notes "This creates a new Actor"
    param :form, :fullname, :string, :required, "The full name of the actor"
    param :form, :email, :string, :required, "The Actor's email address"
    response :ok, "Success", :Actor
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do
    summary "Updates an Actor"
    notes "This updates the Actor matching the given id"
    param :path, :id, :integer, :required, "Actor Id"
    param :form, :fullname, :string, :optional, "The full name of the actor"
    param :form, :email, :string, :optional, "The Actor's email address"
    response :ok, "Success", :Actor
    response :not_found, "Actor not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do
    summary "Deletes an Actor"
    notes "This deletes the Actor matching the given id"
    response :ok, "Success", :Actor
    param :path, :id, :integer, :required, "Actor Id"
    response :not_found, "Actor not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
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
    params.permit(:email, :fullname)
  end

  def set_actor
    @actor = Actor.find(params[:id])
  end
end
