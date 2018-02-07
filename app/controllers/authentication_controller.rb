class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: [:authenticate, :authenticateNoOauth]

  # Swagger specs
  swagger_controller :authentication, "Actors Authentication"

  swagger_api :authenticate do
    summary "Obtains auth token and redirects to UI endpoint"
    notes "This authenticates an Actor against the API and redirects to UI endpoint with token"
    param :query, :code, :string, :required, "OAUTH2 Fiware Lab code"
    response :ok, "Success"
    response :forbidden, "This resource cannot be accessed"
  end

  swagger_api :authenticateNoOauth do
    summary "Obtains auth token"
    notes "This authenticates an Actor against the API and returns a token if oauth not enabled"
    param :query, :code, :string, :required, "OAUTH2 Fiware Lab code"
    response :ok, "Success"
    response :forbidden, "This resource cannot be accessed"
  end

  # Gets auth token once actor is authenticated and redirects to UI
  def authenticate
    #logger.debug 'code: ' + auth_params[:code]
    auth_token = AuthenticateActor.new(auth_params[:code]).call
    #json_response(auth_token: auth_token)
    redirect_to 'http://' + ENV['MASTERMIND_UI_HOST'] + ':' + ENV['MASTERMIND_UI_PORT'] + '/#/login?token=' + auth_token
  end

  # Return auth token once actor is authenticated
  def authenticateNoOauth
    #logger.debug 'code: ' + auth_params[:code]
    if ENV['OAUTH_ENABLED'] && ENV['OAUTH_ENABLED'] == 'false'
      auth_token = JsonWebToken.encode(actor_id: 1)
    end
    json_response(auth_token: auth_token)
  end

  private

  # Allowed params
  def auth_params
    params.permit(:code, :state)
  end
end
