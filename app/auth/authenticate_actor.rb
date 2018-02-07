class AuthenticateActor
  def initialize(code)
    @code = code
  end

  # Service entry point
  def call
    # OAUTH2 credentials for a Fiware app
    oauth_uri = ('https://' + ENV['MASTERMIND_OAUTH_URI']) || 'https://account.lab.fiware.org'
    client_id = ENV['MASTERMIND_OAUTH_CLIENT_ID'] || 'f856da058c20414db0e946d234a5b9b1'
    secret_id = ENV['MASTERMIND_OAUTH_SECRET_ID'] || '08eaae80ae544d66ba858de71adb7421'
    if ENV['MASTERMIND_API_HOST'] && ENV['MASTERMIND_API_PORT']
      redirect_uri = 'http://' + ENV['MASTERMIND_API_HOST'] + ':' + ENV['MASTERMIND_API_PORT'] + '/auth/login'
    else
      redirect_uri = 'http://localhost:3000/auth/login'
    end
    encodedData = 'Basic ' + Base64.strict_encode64(client_id + ':' + secret_id)
    #logger.debug 'Encoded data: ' + encodedData
    client = OAuth2::Client.new(
        client_id,
        secret_id,
        :authorize_url => "/oauth2/authorize",
        :token_url => "/oauth2/token",
        :site => oauth_uri
    )
    token = client.auth_code.get_token(code, :redirect_uri => redirect_uri, :headers => {'Authorization' => encodedData})
    #logger.debug "token " + token.token
    response = token.get('/user', :params => { 'access_token' => token.token })
    email = JSON.parse(response.body)["email"]
    fullname = JSON.parse(response.body)["displayName"]
    actor = Actor.find_by(email: email)
    if actor.nil?
      actor = Actor.create!(email: email, fullname: fullname, superadmin: false)
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
