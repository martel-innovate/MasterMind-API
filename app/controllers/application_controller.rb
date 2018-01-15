class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include Pundit

  # Called before every action on controllers
  before_action :authorize_request
  attr_reader :current_actor

  private

  # Check for valid request token and return actor
  def authorize_request
    @current_actor = (AuthorizeApiRequest.new(request.headers).call)[:actor]
  end

  # Workaround for Pundit
  def current_user
    return current_actor
  end
end
