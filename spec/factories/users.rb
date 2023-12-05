FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { '!TaxTribun2897dxkjanwjk2a1' }
  end
end
