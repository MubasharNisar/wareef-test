FactoryBot.define do
  factory :talent do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
