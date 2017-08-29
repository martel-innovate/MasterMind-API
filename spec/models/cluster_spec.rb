require 'rails_helper'

RSpec.describe Cluster, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:endpoint) }
  it { should validate_presence_of(:cert) }
  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:ca) }
end
