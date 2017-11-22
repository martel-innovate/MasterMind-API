require 'rails_helper'

RSpec.describe NgsiSubscription, type: :model do
  it { should belong_to(:service) }
  it { should belong_to(:project) }
  it { should validate_presence_of(:subscription_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:notification) }
  it { should validate_presence_of(:expires) }
  it { should validate_presence_of(:throttling) }
  it { should validate_presence_of(:status) }
end
