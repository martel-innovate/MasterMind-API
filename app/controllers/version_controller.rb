class VersionController < ApplicationController
  skip_before_action :authorize_request, only: :version

  def version
    ver = ENV['MASTERMIND_VERSION'] || 'Undefined'
    json_response({version: ver})
  end
end
