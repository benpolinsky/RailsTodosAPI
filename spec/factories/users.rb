FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'sample@email.com' }
    password { 'test' }
  end
end
