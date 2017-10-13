FactoryGirl.define do
  factory :ngsi_subscription do
    service_id nil
    subscription_id { Faker::Lorem.word }
    name { Faker::Lorem.word }
    description { Faker::Lorem.word }
    subject { Faker::Lorem.word }
    notification { Faker::Lorem.word }
    expires { Faker::Lorem.word }
    throttling { Faker::Lorem.word }
    status { Faker::Lorem.word }
  end
end
