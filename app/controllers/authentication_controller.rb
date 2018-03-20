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
    auth_token = AuthenticateActor.new(auth_params[:code]).call
    ui_host = Settings.mastermind_ui_host
    ui_port = Settings.mastermind_ui_port.to_s
    redirect_to 'http://' + ui_host + ':' + ui_port + '/auth/#/login?token=' + auth_token
  end

  # Return auth token once actor is authenticated
  def authenticateNoOauth
    if !Settings.oauth_enabled
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
