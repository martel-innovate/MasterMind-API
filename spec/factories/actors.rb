FactoryGirl.define do
  factory :actor do
    email { Faker::Internet.email }
    fullname { Faker::StarWars.character }
  end
end
