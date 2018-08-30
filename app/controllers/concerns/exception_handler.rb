module ExceptionHandler
  extend ActiveSupport::Concern

  # Error classes for the errors
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end

  # Rescue from errors with json responses
  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :not_permitted
    rescue_from ExceptionHandler::InvalidToken, with: :not_permitted
    rescue_from ExceptionHandler::ExpiredSignature, with: :unauthorized_request
    rescue_from JWT::DecodeError, with: :invalid_token

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end

  # JSON response with message; Status code 403 - Forbidden
  def not_permitted(e)
    json_response({ message: e.message }, :forbidden)
  end

  # JSON response with message; Status code 403 - Forbidden
  def invalid_token(e)
    json_response({ message: 'The provided API token is invalid' }, :forbidden)
  end
end
