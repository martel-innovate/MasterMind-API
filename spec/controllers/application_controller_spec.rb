require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  # Create test actor and project
  let(:actor) { create(:actor) }
  let!(:project) { create(:project) }
   # set headers for authorization
  let(:headers) { { 'Authorization' => token_generator(actor.id) } }
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe "#authorize_request" do
    context "when auth token is passed" do
      before { allow(request).to receive(:headers).and_return(headers) }

      # private method authorize_request returns current actor
      it "sets the current actor" do
        expect(subject.instance_eval { authorize_request }).to eq(actor)
      end
    end

    context "when auth token is not passed" do
      before do
        allow(request).to receive(:headers).and_return(invalid_headers)
      end

      it "raises MissingToken error" do
        expect { subject.instance_eval { authorize_request } }.
          to raise_error(ExceptionHandler::MissingToken, /Missing token/)
      end
    end
  end
end
