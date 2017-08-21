require 'rails_helper'

RSpec.describe 'Roles API' do
  # Initialize the test data
  let!(:actor) { create(:actor) }
  let!(:project) { create(:project, actor_id: actor.id) }
  let!(:role_level) { create(:role_level, name: "admin") }
  let!(:roles) { create_list(:role, 20, project_id: project.id, actor_id: actor.id, role_level_id: role_level.id) }
  let(:project_id) { project.id }
  let(:actor_id) { actor.id }
  let(:role_level_id) { role_level.id }
  let(:id) { roles.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /projects/:project_id/roles
  describe 'GET /v1/projects/:project_id/roles' do
    before { get "/v1/projects/#{project_id}/roles", headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all project roles' do
        expect(json.size).to eq(20)
      end
    end

    context 'when project does not exist' do
      let(:project_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end
  end

  # Test suite for GET /projects/:project_id/roles/:id
  describe 'GET /v1/projects/:project_id/roles/:id' do
    before { get "/v1/projects/#{project_id}/roles/#{id}", headers: headers }

    context 'when project actor exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the role' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when project role does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Role/)
      end
    end
  end

  # Test suite for PUT /projects/:project_id/roles
  describe 'POST /v1/projects/:project_id/roles' do
    let(:valid_attributes) do
      { actor_id: actor_id, role_level_id: role_level_id }.to_json
    end

    context 'when request attributes are valid' do
      before { post "/v1/projects/#{project_id}/roles", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/v1/actors", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  # Test suite for DELETE /projects/:id
  describe 'DELETE /v1/projects/:id' do
    before { delete "/v1/projects/#{project_id}/roles/#{id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
