class AuthorizeApiRequest
  # Initialise with optional headers
  def initialize(headers = {})
    @headers = headers
  end

  # Service entry point: return valid actor object
  def call
    {
      actor: actor
    }
  end

  private

  attr_reader :headers

  def actor
    # Check if actor is in the database
    # Memoize actor object
    @actor ||= Actor.find(decoded_auth_token[:actor_id]) if decoded_auth_token
    # Handle actor not found
  rescue ActiveRecord::RecordNotFound => e
    # Raise custom error
    raise(
      ExceptionHandler::InvalidToken,
      ("#{Message.invalid_token} #{e.message}")
    )
  end

  # Decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # Check for token in `Authorization` header
  def http_auth_header
    if headers['Authorization'].present? && headers['Authorization'] != "null"
      return headers['Authorization'].split(' ').last
    end
    raise(ExceptionHandler::InvalidToken, Message.invalid_token)
  end
end
