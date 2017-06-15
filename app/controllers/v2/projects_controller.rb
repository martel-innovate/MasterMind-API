class V2::ProjectsController < ApplicationController
  def index
    json_response({ message: 'Hello there! Please use v1 instead, this is not implemented'})
  end
end
