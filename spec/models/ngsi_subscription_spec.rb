require 'rails_helper'

RSpec.describe NgsiSubscription, type: :model do
  it { should belong_to(:service) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:entities  ) }
  it { should validate_presence_of(:attr) }
  it { should validate_presence_of(:reference) }
  it { should validate_presence_of(:duration) }
  it { should validate_presence_of(:notifyConditions) }
  it { should validate_presence_of(:throttling) }
end
