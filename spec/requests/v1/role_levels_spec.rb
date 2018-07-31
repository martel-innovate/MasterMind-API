require 'rails_helper'

RSpec.describe 'Role Levels API' do
  # initialize test data
  let(:actor) { create(:actor, superadmin: true) }
  let!(:role_levels) { create_list(:role_level, 3) }
  let(:role_level_id) { role_levels.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /role_levels
  describe 'GET /v1/role_levels' do
    # make HTTP get request before each example
    before { get '/v1/role_levels', headers: headers }

    context 'when the actor is superadmin' do
      it 'returns role_levels' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(3)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for GET /role_levels/:id
  describe 'GET /v1/role_levels/:id' do
    before { get "/v1/role_levels/#{role_level_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the role levels' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(role_level_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:role_level_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find RoleLevel/)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for POST /todos
  describe 'POST /v1/role_levels' do
    # valid payload
    let(:valid_attributes) do
      { name: 'Admin'}.to_json
    end

    context 'when the request is valid' do
      before { post '/v1/role_levels', params: valid_attributes, headers: headers }

      it 'creates a role level' do
        expect(json['name']).to eq('Admin')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }
      before { post '/v1/role_levels', params: valid_attributes, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for PUT /role_levels/:id
  describe 'PUT /v1/role_levels/:id' do
    let(:valid_attributes) do
      { name: 'User'}.to_json
    end

    context 'when the record exists' do
      before { put "/v1/role_levels/#{role_level_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }
      before { put "/v1/role_levels/#{role_level_id}", params: valid_attributes, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for DELETE /todos/:id
  describe 'DELETE /v1/role_levels/:id' do
    before { delete "/v1/role_levels/#{role_level_id}", headers: headers }

    context 'when the actor is superadmin' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
