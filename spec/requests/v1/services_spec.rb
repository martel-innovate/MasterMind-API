require 'rails_helper'

RSpec.describe 'Services API' do
  # initialize test data
  let!(:actor) { create(:actor) }
  let!(:project) { create(:project, actor_id: actor.id) }
  let!(:service_type) { create(:service_type) }
  let(:project_id) { project.id }
  let!(:services) { create_list(:service, 10, project_id: project.id, service_type_id: service_type.id) }
  let(:id) {services.first.id}
  let(:service_type_id) { service_type.id }

  # Test suite for GET /projects/:project_id/services
  describe 'GET /v1/projects/:project_id/services' do
    before { get "/v1/projects/#{project_id}/services" }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all project services' do
        expect(json.size).to eq(10)
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

  # Test suite for GET /projects/:project_id/services/:id
  describe 'GET /v1/projects/:project_id/services/:id' do
    before { get "/v1/projects/#{project_id}/services/#{id}" }

    context 'when project service exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the service' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when project service does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Service/)
      end
    end
  end

  # Test suite for PUT /projects/:project_id/services
  describe 'POST /v1/projects/:project_id/services' do
   let(:valid_attributes) { { configuration: 'TestConf', status: 'active', managed: 'true', endpoint: 'test', docker_service_id: '0123456789', latitude: '33.7787', longitude: '-116.3598', service_type_id: service_type_id} }

    context 'when request attributes are valid' do
      before { post "/v1/projects/#{project_id}/services", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  # Test suite for DELETE /projects/:id
  describe 'DELETE /v1/projects/:id' do
    before { delete "/v1/projects/#{project_id}/services/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end




end