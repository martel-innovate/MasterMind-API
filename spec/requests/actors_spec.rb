require 'rails_helper'

RSpec.describe 'Actors API' do
  # Initialize the test data
  let!(:project) { create(:project) }
  let!(:actors) { create_list(:actor, 20, project_id: project.id) }
  let(:project_id) { project.id }
  let(:id) { actors.first.id }

  # Test suite for GET /projects/:project_id/actors
  describe 'GET /projects/:project_id/actors' do
    before { get "/projects/#{project_id}/actors" }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all project actors' do
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

  # Test suite for GET /projects/:project_id/actors/:id
  describe 'GET /projects/:project_id/actors/:id' do
    before { get "/projects/#{project_id}/actors/#{id}" }

    context 'when project actor exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the actor' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when project actor does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Actor/)
      end
    end
  end

  # Test suite for PUT /projects/:project_id/actors
  describe 'POST /projects/:project_id/actors' do
    let(:valid_attributes) { { email: 'someone@hotmail.com', fullname: 'Foobar' } }

    context 'when request attributes are valid' do
      before { post "/projects/#{project_id}/actors", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/projects/#{project_id}/actors", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Email can't be blank/)
      end
    end
  end

  # Test suite for PUT /projects/:project_id/actors/:id
  describe 'PUT /projects/:project_id/actors/:id' do
    let(:valid_attributes) { { email: 'someoneElse@hotmail.com' } }

    before { put "/projects/#{project_id}/actors/#{id}", params: valid_attributes }

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

  # Test suite for DELETE /projects/:id
  describe 'DELETE /projects/:id' do
    before { delete "/projects/#{project_id}/actors/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
