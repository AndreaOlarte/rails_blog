FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    content {  Faker::Movie.quote }
  end
end