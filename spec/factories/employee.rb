FactoryBot.define do
  factory :employee do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    password { '!TaxTribun2897dxkjanwjk2a1' }
    confirmed_at { 1.hour.ago }
  end
end
