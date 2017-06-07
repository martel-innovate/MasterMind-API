class ActorsController < ApplicationController
  before_action :set_project
  before_action :set_project_actor, only: [:show, :update, :destroy]

  # GET /projects/:project_id/actors
  def index
    json_response(@project.actors)
  end

  # GET /projects/:project_id/actors/:id
  def show
    json_response(@actor)
  end

  # POST /projects/:project_id/actors
  def create
    @project.actors.create!(actor_params)
    json_response(@project, :created)
  end

  # PUT /projects/:project_id/actors/:id
  def update
    @actor.update(actor_params)
    head :no_content
  end

  # DELETE /projects/:project_id/actors/:id
  def destroy
    @actor.destroy
    head :no_content
  end

  private

  def actor_params
    params.permit(:email, :fullname)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_actor
    @actor = @project.actors.find_by!(id: params[:id]) if @project
  end
end
