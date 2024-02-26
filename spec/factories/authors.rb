# In spec/factories/factories.rb
FactoryBot.define do
  factory :author do
    name { 'Jon Doe' }
    email { 'jon@example.com' }
    # other attributes
  end
end
