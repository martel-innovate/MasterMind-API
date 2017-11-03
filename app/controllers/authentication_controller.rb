class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

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
    #auth_token = AuthenticateActor.new(auth_params[:code]).call
    auth_token = JsonWebToken.encode(actor_id: "1")
    #Warning.warn("WARNING: OAUTH CURRENTLY DISABLED\n")
    logger.debug "WARNING: OAUTH CURRENTLY DISABLED"
    json_response(auth_token: auth_token)
  end

  private

  def auth_params
    params.permit(:code)
  end
end
