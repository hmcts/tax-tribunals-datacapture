FactoryBot.define do
  factory :employee do
    email { Faker::Internet.email }
    password { '!TaxTribun2897dxkjanwjk2a1' }
    confirmed_at { 1.hour.ago }
  end
end
