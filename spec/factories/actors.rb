FactoryGirl.define do
  factory :actor do
    email { Faker::Internet.email }
    fullname { Faker::StarWars.character }
    superadmin { false }
  end
end
