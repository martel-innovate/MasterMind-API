class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: [:authenticate]

  swagger_controller :authentication, "Actors Authentication"

  swagger_api :authenticate do
    summary "Obtains auth token"
    notes "This authenticates an Actor against the API and returns a token"
    param :query, :code, :string, :required, "OAUTH2 Fiware Lab code"
    response :ok, "Success"
    response :forbidden, "This resource cannot be accessed"
  end

  # return auth token once actor is authenticated
  def authenticate
    #logger.debug 'code: ' + auth_params[:code]
    auth_token = AuthenticateActor.new(auth_params[:code]).call
    #json_response(auth_token: auth_token)
    redirect_to 'http://localhost:8080/#/login?token=' + auth_token
  end

  private

  def auth_params
    params.permit(:code, :state)
  end
end
