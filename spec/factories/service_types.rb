FactoryGirl.define do
  factory :service_type do
    name { Faker::Lorem.word }
    service_protocol_type { Faker::Lorem.word }
    ngsi_version { Faker::Lorem.word }
    configuration_template { Faker::Lorem.word }
    deploy_template { Faker::Lorem.word }
  end
end
