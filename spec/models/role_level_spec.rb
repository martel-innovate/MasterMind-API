require 'rails_helper'

RSpec.describe RoleLevel, type: :model do
  it { should have_many(:roles).dependent(:destroy) }
end
