require 'rails_helper'

RSpec.describe 'Services API' do
  # initialize test data
  let!(:actor) { create(:actor) }
  let!(:project) { create(:project) }
  let!(:cluster) { create(:cluster) }
  let!(:project_unathorised) { create(:project) }
  let!(:service_type) { create(:service_type) }
  let(:project_id) { project.id }
  let!(:service) { create(:service, project_id: project.id, service_type_id: service_type.id, cluster_id: cluster.id) }
  let!(:service_unathorised) { create(:service, project_id: project_unathorised.id, service_type_id: service_type.id, cluster_id: cluster.id) }
  let(:service_id) {service.id}
  let(:service_id_unathorised) {service_unathorised.id}
  let!(:ngsi_subscription) { create_list(:ngsi_subscription, 10, service_id: service_id, project_id: project.id) }
  let!(:ngsi_subscription_unathorised) { create_list(:ngsi_subscription, 10, service_id: service_id_unathorised, project_id: project_unathorised.id) }
  let(:id) {ngsi_subscription.first.id}
  let(:id_unathorised) {ngsi_subscription_unathorised.first.id}
  let(:service_type_id) { service_type.id }
  let(:cluster_id) { cluster.id }
  let(:role_level) { create(:role_level, name: "user") }
  let!(:role) { create(:role, project_id: project.id, actor_id: actor.id, role_level_id: role_level.id, subscriptions_permissions: true) }
  let(:headers) { valid_headers }

  # Test suite for GET /projects/:project_id/ngsi_subscriptions
  describe 'GET /v1/projects/:project_id/ngsi_subscriptions?service_id=service_id' do
    before { get "/v1/projects/#{project_id}/ngsi_subscriptions", headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all project subscriptions' do
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

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for GET /projects/:project_id/ngsi_subscriptions/:id
  describe 'GET /v1/projects/:project_id/ngsi_subscriptions/:id' do
    before { get "/v1/projects/#{project_id}/ngsi_subscriptions/#{id}", headers: headers }

    context 'when subscription exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the service' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when subscription does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find NgsiSubscription/)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }
      let(:id) {id_unathorised}

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for POST /projects/:project_id/ngsi_subscriptions
  describe 'POST /v1/projects/:project_id/ngsi_subscriptions' do
   let(:valid_attributes) do
     { service_id: service_id, subscription_id: 'foobar', name: 'Test', description: 'Test', subject: '{}', notification: '{}', expires: 'sometime', throttling: '5', status: 'inactive'}.to_json
   end

    context 'when request attributes are valid' do
      before { post "/v1/projects/#{project_id}/ngsi_subscriptions", headers: headers, params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }
      before { post "/v1/projects/#{project_id}/ngsi_subscriptions", headers: headers, params: valid_attributes }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  # Test suite for DELETE /projects/:project_id/ngsi_subscriptions
  describe 'DELETE /v1/projects/:project_id/ngsi_subscriptions' do
    context 'when the actor does have permission' do
      before { delete "/v1/projects/#{project_id}/ngsi_subscriptions/#{id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorised.id }
      let(:id) {id_unathorised}
      before { delete "/v1/projects/#{project_id}/ngsi_subscriptions/#{id}", headers: headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end
