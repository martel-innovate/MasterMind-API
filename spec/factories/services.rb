FactoryGirl.define do
  factory :service do
    configuration { Faker::Lorem.word }
    status { Faker::Lorem.word }
    managed { Faker::Lorem.word }
    endpoint { Faker::Lorem.word }
    docker_service_id { Faker::Lorem.word }
    latitude { Faker::Lorem.word }
    longitude { Faker::Lorem.word }
  end
end
