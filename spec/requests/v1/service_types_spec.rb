require 'rails_helper'

RSpec.describe 'Service Types API' do
  # initialize test data
  let!(:service_types) { create_list(:service_type, 3) }
  let(:service_type_id) {service_types.first.id}

  # Test suite for GET /service_types
  describe 'GET /v1/service_types' do
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

  # Test suite for GET /service_types/:id
  describe 'GET /v1/service_types/:id' do
    before { get "/v1/service_types/#{service_type_id}" }

    context 'when the record exists' do
      it 'returns the service types' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(service_type_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:service_type_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find ServiceType/)
      end
    end
  end

  # Test suite for POST /service_types
  describe 'POST /v1/service_types' do
    # valid payload
    let!(:valid_attributes) { { name: 'Orion', version: '1.0', service_protocol_type: 'HTTP', ngsi_version: '9', configuration_template: 'test', deploy_template: 'test'} }

    context 'when the request is valid' do
      before { post '/v1/service_types', params: valid_attributes }

      it 'creates a service type' do
        expect(json['name']).to eq('Orion')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  # Test suite for PUT /service_types/:id
  describe 'PUT /v1/service_types/:id' do
    let!(:valid_attributes) { { name: 'Orion2', version: '2.0', service_protocol_type: 'HTTP', ngsi_version: '9', configuration_template: 'test', deploy_template: 'test'} }

    context 'when the record exists' do
      before { put "/v1/service_types/#{service_type_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /service_types/:id
  describe 'DELETE /v1/service_types/:id' do
    before { delete "/v1/service_types/#{service_type_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end
