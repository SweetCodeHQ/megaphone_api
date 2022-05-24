FactoryBot.define do

  factory :admin_user do
    email     { Faker::Internet.email }
    is_admin  { true }
  end
end
