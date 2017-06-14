require 'rails_helper'

RSpec.describe Actor, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:fullname) }
  it { should have_many(:projects) }
  it { should have_many(:roles) }
end
