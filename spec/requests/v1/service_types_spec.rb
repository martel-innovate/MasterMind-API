require 'rails_helper'

RSpec.describe 'Service Types API' do
  # initialize test data
  let(:actor) { create(:actor, superadmin: true) }
  let!(:project) { create(:project) }
  let!(:project_unathorised) { create(:project) }
  let(:actor_id) { actor.id }
  let!(:role_level) { create(:role_level, name: "admin") }
  let!(:service_types) { create_list(:service_type, 3) }
  let!(:service_types_imported) { create_list(:service_type, 4, project_id: project.id, is_imported: true) }
  let!(:service_types_imported_unathorized) { create_list(:service_type, 4, project_id: project_unathorised.id, is_imported: true) }
  let(:service_type_id) {service_types.first.id}
  let(:service_type_imported_id) {service_types_imported.first.id}
  let(:service_types_imported_unathorized_id) {service_types_imported_unathorized.first.id}
  let!(:role) { create(:role, project_id: project.id, actor_id: actor.id, role_level_id: role_level.id) }
  let(:headers) { valid_headers }

  # Test suite for GET /service_types
  describe 'GET /v1/service_types' do
    context 'when querying the main catalog' do
      # make HTTP get request before each example
      before {get "/v1/service_types",  params: {}, headers: headers }

        it 'returns service_types' do
          # Note `json` is a custom helper to parse JSON responses
          expect(json).not_to be_empty
          expect(json.size).to eq(3)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
    end

    context 'when querying imported service types' do
      # make HTTP get request before each example
      before {get "/v1/service_types",  params: {project_id: project.id}, headers: headers }

        it 'returns service_types' do
          # Note `json` is a custom helper to parse JSON responses
          expect(json).not_to be_empty
          expect(json.size).to eq(4)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
    end
  end

  # Test suite for GET /service_types/:id
  describe 'GET /v1/service_types/:id' do
    context 'when the record exists' do
      before { get "/v1/service_types/#{service_type_id}", headers: headers }

      it 'returns the service types' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(service_type_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record exists and is imported' do
      before { get "/v1/service_types/#{service_type_imported_id}", headers: headers }

      it 'returns the service types' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(service_type_imported_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:service_type_id) { 100 }
      before { get "/v1/service_types/#{service_type_id}", headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find ServiceType/)
      end
    end

    context 'when the record does exist, is imported, but the actor has no permission to see it' do
      let(:actor) { create(:actor, superadmin: false) }
      before { get "/v1/service_types/#{service_types_imported_unathorized_id}", headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for POST /service_types
  describe 'POST /v1/service_types' do
    # valid payload
    let!(:valid_attributes) do
      { name: 'Orion', version: '1.0', service_protocol_type: 'HTTP', ngsi_version: '9', configuration_template: 'test', deploy_template: 'test', is_imported: false, project_id: 0}.to_json
    end

    context 'when the request is valid' do
      before { post '/v1/service_types', params: valid_attributes, headers: headers }

      it 'creates a service type' do
        expect(json['name']).to eq('Orion')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the service type is imported and the actor doesnt have a role in the project' do
      let(:actor) { create(:actor, superadmin: false) }
      let!(:valid_attributes) do
        { name: 'Orion', version: '1.0', service_protocol_type: 'HTTP', ngsi_version: '9', configuration_template: 'test', deploy_template: 'test', is_imported: true, project_id: project_unathorised.id}.to_json
      end
      before { post '/v1/service_types', params: valid_attributes, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }
      before { post '/v1/service_types', params: valid_attributes, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for PUT /service_types/:id
  describe 'PUT /v1/service_types/:id' do
    let!(:valid_attributes) do
      { name: 'Orion2', version: '2.0', service_protocol_type: 'HTTP', ngsi_version: '9', configuration_template: 'test', deploy_template: 'test'}.to_json
    end

    context 'when the record exists' do
      before { put "/v1/service_types/#{service_type_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the service type is imported and the actor doesnt have a role in the project' do
      let(:actor) { create(:actor, superadmin: false) }
      before { put "/v1/service_types/#{service_types_imported_unathorized_id}", params: valid_attributes, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }
      before { put "/v1/service_types/#{service_type_id}", params: valid_attributes, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for DELETE /service_types/:id
  describe 'DELETE /v1/service_types/:id' do
    context 'when the record exists' do
      before { delete "/v1/service_types/#{service_type_id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the service type is imported and the actor doesnt have a role in the project' do
      let(:actor) { create(:actor, superadmin: false) }
      before { delete "/v1/service_types/#{service_types_imported_unathorized_id}", headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the actor is not superadmin' do
      let(:actor) { create(:actor, superadmin: false) }
      before { delete "/v1/service_types/#{service_type_id}", headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

end
