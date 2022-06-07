FactoryBot.define do

  factory :user do
    email       { Faker::Internet.email }

    factory :admin_user do
      is_admin  { true }
    end
  end

  factory :entity do
    name        { Faker::Company.name }
    url         { Faker::Internet.domain_name }
  end

  factory :user_entity do
    user    { User.last }
    entity  { Entity.last }
  end
end
