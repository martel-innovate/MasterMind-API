FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.word }
    description { Faker::Lorem.word }
  end
end
