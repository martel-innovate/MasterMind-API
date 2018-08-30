class VersionController < ApplicationController
  skip_before_action :authorize_request, only: :version

  # Swagger specs
  swagger_controller :version, "Version Endpoint"

  swagger_api :version do
    summary "Obtains MasterMind version"
    notes "This gets the version of MasterMind"
    response :ok, "Success"
  end

  # GET /version
  def version
    ver = Settings.mastermind_version.to_s
    json_response({version: ver})
  end
end
