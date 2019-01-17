FactoryBot.define do
  factory :user do
    name { Faker::Simpsons.character }
    email { Faker::Internet.email }
    password { Faker::Internet.password(6) }
    description { Faker::Simpsons.quote }
  end
end