FactoryBot.define do
  factory :tag do
    category { Faker::Book.genre }
  end
end
