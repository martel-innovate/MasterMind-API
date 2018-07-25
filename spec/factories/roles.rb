FactoryGirl.define do
  factory :role do
    project_id nil
    actor_id nil
    role_level_id nil
    clusters_permissions false
    services_permissions false
    subscriptions_permissions false
  end
end
