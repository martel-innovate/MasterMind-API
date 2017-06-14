class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate
  # return auth token once actor is authenticated
  def authenticate
    auth_token = AuthenticateActor.new(auth_params[:code]).call
    puts auth_token
    json_response(auth_token: auth_token)
  end

  private

  def auth_params
    params.permit(:code)
  end
end
