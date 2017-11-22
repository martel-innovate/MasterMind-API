require 'rails_helper'

RSpec.describe Actor, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:fullname) }
  it { should validate_inclusion_of(:superadmin).in_array([true, false]) }
  it { should have_many(:roles) }
end
