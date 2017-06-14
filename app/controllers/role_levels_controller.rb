class RoleLevelsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_role_level, only: [:show, :update, :destroy]

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
