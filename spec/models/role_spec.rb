require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should belong_to(:project) }
  it { should belong_to(:actor) }
  it { should belong_to(:role_level) }
end
