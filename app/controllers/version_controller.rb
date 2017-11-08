class VersionController < ApplicationController
  skip_before_action :authorize_request, only: :version

  swagger_controller :version, "Version Endpoint"

  swagger_api :version do
    summary "Obtains MasterMind version"
    notes "This gets the version of MasterMind"
    response :ok, "Success"
    response :forbidden, "This resource cannot be accessed"
  end

  def version
    ver = ENV['MASTERMIND_VERSION'] || 'Undefined'
    json_response({version: ver})
  end
end
