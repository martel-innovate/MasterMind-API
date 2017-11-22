require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should have_many(:roles) }
  it { should have_many(:services) }
  it { should have_many(:ngsi_subscriptions) }
end
