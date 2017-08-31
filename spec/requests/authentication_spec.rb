require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  # Authentication test suite
  describe 'POST /auth/login' do
    # Create test actor and project
    let(:actor) { create(:actor) }
    let!(:project) { create(:project) }
    # set headers for authorization
    let(:headers) { valid_headers.except('Authorization') }
    # set test valid and invalid credentials
    let(:valid_credentials) do
      {
        email: actor.email,
        fullname: actor.fullname
      }.to_json
    end
    let(:invalid_credentials) do
      {
        email: nil,
        fullname: nil,
      }.to_json
    end
  end
end
