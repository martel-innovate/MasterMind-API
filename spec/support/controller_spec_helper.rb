module ControllerSpecHelper
  # generate tokens from actor id
  def token_generator(actor_id)
    JsonWebToken.encode(actor_id: actor_id)
  end

  # generate expired tokens from actor id
  def expired_token_generator(actor_id)
    JsonWebToken.encode({ actor_id: actor_id }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers
    {
      "Authorization" => token_generator(actor.id),
      "Content-Type" => "application/json"
    }
  end

  # return invalid headers
  def invalid_headers
    {
      "Authorization" => nil,
      "Content-Type" => "application/json"
    }
  end
end
