require 'rails_helper'

RSpec.describe 'Clusters API' do
  # Initialize the test data
  let!(:actor) { create(:actor) }
  let!(:project) { create(:project) }
  let!(:project_unathorised) { create(:project) }
  let!(:clusters) { create_list(:cluster, 20, project_id: project.id) }
  let!(:clusters_unathorised) { create_list(:cluster, 20, project_id: project_unathorised.id) }
  let(:project_id) { project.id }
  let(:actor_id) { actor.id }
  let(:id) { clusters.first.id }
  let(:role_level) { create(:role_level, name: "admin") }
  let!(:role) { create(:role, project_id: project.id, actor_id: actor.id, role_level_id: role_level.id) }
  let(:headers) { valid_headers }

  # Test suite for GET /projects/:project_id/clusters
  describe 'GET /v1/projects/:project_id/clusters' do
    before { get "/v1/projects/#{project_id}/clusters", headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all project clusters' do
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

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for GET /projects/:project_id/clusters/:id
  describe 'GET /v1/projects/:project_id/clusters/:id' do
    before { get "/v1/projects/#{project_id}/clusters/#{id}", headers: headers }

    context 'when project cluster exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the role' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when project cluster does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Cluster/)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }
      let(:id) { clusters_unathorised.first.id }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for PUT /projects/:project_id/roles
  describe 'POST /v1/projects/:project_id/clusters' do
    let(:valid_attributes) do
      { name: 'TestCluster', description: 'Stuff', endpoint: 'tcp://0.0.0.0:2324', cert: 'ssdffsf', key: 'sffsdsfd', ca: 'adsadsads' }.to_json
    end

    context 'when request attributes are valid' do
      before { post "/v1/projects/#{project_id}/clusters", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/v1/projects/#{project_id}/clusters", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }
      before { post "/v1/projects/#{project_id}/clusters", params: {}, headers: headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for DELETE /projects/:id
  describe 'DELETE /v1/projects/:id' do
    context 'when the actor does have permission' do
      before { delete "/v1/projects/#{project_id}/clusters/#{id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }
      let(:id) { clusters_unathorised.first.id }
      before { delete "/v1/projects/#{project_id}/clusters/#{id}", headers: headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end
