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
    rescue_from ExceptionHandler::ExpiredSignature, with: :four_ninety_eight

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 498 - expired signature
  def four_ninety_eight(e)
    json_response({ message: e.message }, 498)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end

  # JSON response with message; Status code 403 - Forbidden
  def not_permitted(e)
    json_response({ message: e.message }, :forbidden)
  end
end
