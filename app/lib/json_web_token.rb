class JsonWebToken
  # Secret to encode and decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  # Encode token with JWT
  def self.encode(payload, exp = 24.hours.from_now)
    # set expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  # Decode token with JWT
  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body
  # Rescue from expiry exception
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    # Raise custom error to be handled by custom handler
    raise ExceptionHandler::ExpiredSignature, e.message
  end
end
