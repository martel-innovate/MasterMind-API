class AuthenticateActor
  def initialize(code)
    @code = code
  end

  # Service entry point
  def call
    # OAUTH2 credentials for a Fiware app
    oauth_uri = 'https://' + Settings.mastermind_oauth_uri
    client_id = Settings.mastermind_oauth_client_id
    secret_id = Settings.mastermind_oauth_client_secret
    redirect_uri = 'http://' + Settings.mastermind_api_host + ':' + Settings.mastermind_api_port.to_s + '/auth/login'
    encodedData = 'Basic ' + Base64.strict_encode64(client_id + ':' + secret_id)
    client = OAuth2::Client.new(
        client_id,
        secret_id,
        :authorize_url => "/oauth2/authorize",
        :token_url => "/oauth2/token",
        :site => oauth_uri
    )
    token = client.auth_code.get_token(code, :redirect_uri => redirect_uri, :headers => {'Authorization' => encodedData})
    #response = token.get('/user', :params => { 'access_token' => token.token })
    response = RestClient.get(oauth_uri + '/user?access_token=' + token.token)
    email = JSON.parse(response.body)["email"]
    fullname = JSON.parse(response.body)["displayName"]
    actor = Actor.find_by(email: email)
    if actor.nil?
      actor = Actor.create!(email: email, fullname: fullname, superadmin: false)
    end
    roles = JSON.parse(response.body)["roles"]
    roles.each do |role|
      if role['name'] == 'Admin' || role['name'] == 'admin' then
        if !actor.superadmin then
          actor.superadmin = true
          actor.save
        end
      end
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
