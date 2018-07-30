require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should belong_to(:project) }
  it { should belong_to(:actor) }
  it { should belong_to(:role_level) }
  it { should validate_inclusion_of(:clusters_permissions).in_array([true, false]) }
  it { should validate_inclusion_of(:services_permissions).in_array([true, false]) }
  it { should validate_inclusion_of(:subscriptions_permissions).in_array([true, false]) }
end
