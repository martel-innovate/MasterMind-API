class AuthenticateActor
  def initialize(code)
    @code = code
  end

  # Service entry point
  def call
    client = OAuth2::Client.new(
      "88c5dd13710847f79a22e2df37fe2691",
      "b73b11fe7c4f4808a2e01c361a93c8f0",
      :authorize_url => "/oauth2/authorize",
      :token_url => "/oauth2/token",
      :site => "https://account.lab.fiware.org"
    )
    token = client.auth_code.get_token(code, :redirect_uri => 'http://localhost:8080/', :headers => {'Authorization' => 'Basic ODhjNWRkMTM3MTA4NDdmNzlhMjJlMmRmMzdmZTI2OTE6YjczYjExZmU3YzRmNDgwOGEyZTAxYzM2MWE5M2M4ZjA='})
    response = token.get('/user', :params => { 'access_token' => token.token })
    email = JSON.parse(response.body)["email"]
    fullname = JSON.parse(response.body)["displayName"]
    actor = Actor.find_by(email: email)
    if actor.nil?
      actor = Actor.create!(email: email, fullname: fullname)
    end
    return JsonWebToken.encode(actor_id: actor.id)
  rescue ActiveRecord::RecordNotFound => e
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  rescue OAuth2::Error => e
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  private

  attr_reader :code

end
