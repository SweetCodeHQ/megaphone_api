FactoryBot.define do

  factory :user do
    email     { Faker::Internet.email }

    factory :admin_user do
      is_admin  { true }
    end
  end
end
