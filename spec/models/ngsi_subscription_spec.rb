require 'rails_helper'

RSpec.describe NgsiSubscription, type: :model do
  it { should belong_to(:service) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:notification) }
  it { should validate_presence_of(:expires) }
  it { should validate_presence_of(:throttling) }
end
