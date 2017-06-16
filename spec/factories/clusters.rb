FactoryGirl.define do
  factory :cluster do
    name { Faker::Lorem.word }
    description { Faker::Lorem.word }
    endpoint { Faker::Lorem.word }
    cert { Faker::Lorem.word }
    key { Faker::Lorem.word }
    ca { Faker::Lorem.word }
  end
end
