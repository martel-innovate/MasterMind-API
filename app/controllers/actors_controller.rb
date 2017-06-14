class ActorsController < ApplicationController
  skip_before_action :authorize_request
  before_action :set_actor, only: [:show, :update, :destroy]

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
