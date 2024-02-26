# spec/factories/courses.rb
FactoryBot.define do
  factory :course do
    title { Faker::Lorem.sentence }
    code { Faker::Lorem.word }
    author
  end
end