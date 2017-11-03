class V1::RoleLevelsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_role_level, only: [:show, :update, :destroy]

  swagger_controller :role_levels, "Role Levels Management"

  swagger_api :index do
    summary "Fetches all Role Levels"
    notes "This lists all the active Role Levels"
    response :ok, "Success", :RoleLevel
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :show do
    summary "Fetches a specific Role Level"
    notes "This fetches the Role Level matching the given id"
    param :path, :id, :integer, :required, "Role Level Id"
    response :ok, "Success", :RoleLevel
    response :not_found, "Role Level not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :create do
    summary "Creates a Role Level"
    notes "This creates a new Role Level"
    param :form, :name, :string, :required, "The name associated to this Role Level"
    response :ok, "Success", :Actor
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :update do
    summary "Updates a Role Level"
    notes "This updates the Role Level matching the given id"
    param :path, :id, :integer, :required, "Role Level Id"
    param :form, :name, :string, :required, "The name associated to this Role Level"
    response :ok, "Success", :RoleLevel
    response :not_found, "Role Level not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
    response :unprocessable_entity, "Invalid entity provided"
  end

  swagger_api :destroy do
    summary "Deletes a Role Level"
    notes "This deletes the Role Level matching the given id"
    response :ok, "Success", :Actor
    param :path, :id, :integer, :required, "Role Level Id"
    response :not_found, "Role Level not found"
    response :unauthorized, "The actor does not have permission to perform this action"
    response :invalid_token, "The provided API token is invalid"
    response :forbidden, "This resource cannot be accessed"
  end

  # GET /role_levels
  def index
    @role_levels = RoleLevel.all
    json_response(@role_levels)
  end

  # POST /role_levels
  def create
    @role_level = RoleLevel.create!(role_level_params)
    json_response(@role_level, :created)
  end

  # GET /role_levels/:id
  def show
    json_response(@role_level)
  end

  # PUT /role_levels/:id
  def update
    @role_level.update(role_level_params)
    head :no_content
  end

  # DELETE /role_levels/:id
  def destroy
    @role_level.destroy
    head :no_content
  end

  private

  def role_level_params
    # whitelist params
    params.permit(:name)
  end

  def set_role_level
    @role_level = RoleLevel.find(params[:id])
  end
end
