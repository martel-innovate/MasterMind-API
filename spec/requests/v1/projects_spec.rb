require 'rails_helper'

RSpec.describe 'Projects API', type: :request do
  # initialize test data
  let(:actor) { create(:actor) }
  let!(:projects) { create_list(:project, 10) }
  let(:project_unathorized) { create(:project) }
  let(:project_id) { projects.first.id }
  let(:project_unathorized_id) { project_unathorized.id }
  let(:role_level) { create(:role_level, name: "admin") }
  let!(:role) { create(:role, project_id: projects.first.id, actor_id: actor.id, role_level_id: role_level.id, clusters_permissions: true, services_permissions: true, subscriptions_permissions: true) }
  let(:headers) { valid_headers }

  # Test suite for GET /projects
  describe 'GET /v1/projects' do
    # make HTTP get request before each example
    before { get '/v1/projects', params: {}, headers: headers }

    context 'when not superadmin' do
      it 'returns projects' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when superadmin' do
      let(:actor) { create(:actor, superadmin: true) }
      it 'returns projects' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for GET /projects/:id
  describe 'GET /v1/projects/:id' do
    before { get "/v1/projects/#{project_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the project' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(project_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:project_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end

    context 'when the actor does not have a role in the project' do
      let(:project_id) { project_unathorized_id }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the actor is a superadmin' do
      let(:project_id) { project_unathorized_id }
      let(:actor) { create(:actor, superadmin: true) }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for POST /todos
  describe 'POST /v1/projects' do
    # valid payload
    let(:valid_attributes) do
      { name: 'Learn Elm', description: 'foobar' }.to_json
    end

    context 'when the request is valid' do
      before { post '/v1/projects', params: valid_attributes, headers: headers }

      it 'creates a project' do
        expect(json['name']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { name: "Foobar" }.to_json }
      before { post '/v1/projects', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Description can't be blank/)
      end
    end
  end

  # Test suite for PUT /projects/:id
  describe 'PUT /v1/projects/:id' do
    let(:valid_attributes) { { name: 'Foobar' }.to_json }

    context 'when the record exists' do
      before { put "/v1/projects/#{project_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorized_id }
      before { put "/v1/projects/#{project_id}", params: valid_attributes, headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the actor is a superadmin' do
      let(:project_id) { project_unathorized_id }
      let(:actor) { create(:actor, superadmin: true) }
      before { put "/v1/projects/#{project_id}", params: valid_attributes, headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /todos/:id
  describe 'DELETE /v1/projects/:id' do
    context 'when the actor does have permission' do
      before { delete "/v1/projects/#{project_id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the actor does not have permission' do
      let(:project_id) { project_unathorized_id }
      before { put "/v1/projects/#{project_id}", headers: headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the actor is a superadmin' do
      let(:project_id) { project_unathorized_id }
      let(:actor) { create(:actor, superadmin: true) }
      before { put "/v1/projects/#{project_id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
