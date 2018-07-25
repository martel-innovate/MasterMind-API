require 'rails_helper'

RSpec.describe 'Actors API', type: :request do
  # Initialize the test data
  let(:actor) { create(:actor, superadmin: true) }
  let!(:actors) { create_list(:actor, 19, superadmin: false) }
  let(:id) { actors.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /actors
  describe 'GET /v1/actors' do
    before { get "/v1/actors", headers: headers }

    context 'when actors exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all actors' do
        expect(json.size).to eq(20)
      end
    end
  end

  # Test suite for GET /v1/actors/:id
  describe 'GET /v1/actors/:id' do
    before { get "/v1/actors/#{id}", headers: headers }

    context 'when actor exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the actor' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when actor does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Actor/)
      end
    end
  end

  # Test suite for POST /actors
  describe 'POST /v1/actors' do
    let(:valid_attributes) do
      { email: 'someone@hotmail.com', fullname: 'someone', superadmin: true }.to_json
    end

    context 'when request attributes are valid' do
      before { post '/v1/actors', params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/v1/actors", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Email can't be blank/)
      end
    end
  end

  # Test suite for PUT /actors/:id
  describe 'PUT /v1/actors/:id' do
    let(:valid_attributes) do
      { email: 'someoneElse@hotmail.com' }.to_json
    end

    before { put "/v1/actors/#{id}", params: valid_attributes, headers: headers }

    context 'when actor exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the actor' do
        updated_actor = Actor.find(id)
        expect(updated_actor.email).to match(/someoneElse@hotmail.com/)
      end
    end

    context 'when the actor does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Actor/)
      end
    end
  end

  # Test suite for DELETE /actors/:id
  describe 'DELETE /v1/actors/:id' do
    before { delete "/v1/actors/#{id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
