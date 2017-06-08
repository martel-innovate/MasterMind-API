require 'rails_helper'

RSpec.describe Actor, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:fullname) }
  it { should belong_to(:project) }
  it { should have_many(:roles) }
end
