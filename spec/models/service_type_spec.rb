require 'rails_helper'

RSpec.describe ServiceType, type: :model do

    # Association test
    # ensure Service Type model has a 1:n relationship with the Service model
    it { should have_many(:services) }

    # Validation tests
    # ensure all columns are created before saving
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:version) }
    it { should validate_presence_of(:service_protocol_type) }
    it { should validate_presence_of(:ngsi_version) }
    it { should validate_presence_of(:configuration_template) }
    it { should validate_presence_of(:deploy_template) }
    it { should validate_inclusion_of(:is_imported).in_array([true, false]) }
    it { should validate_presence_of(:project_id) }
end
