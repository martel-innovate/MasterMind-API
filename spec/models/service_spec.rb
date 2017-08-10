require 'rails_helper'

RSpec.describe Service, type: :model do

    # Association tests
    # ensure a service record belongs to a single service_type record
    it { should belong_to(:service_type) }
    it { should belong_to(:project) }

    # Validation test
    # ensure columns are present before saving
    it { should validate_presence_of(:configuration) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:managed) }
    it { should validate_presence_of(:endpoint) }
    it { should validate_presence_of(:docker_service_id) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
end
