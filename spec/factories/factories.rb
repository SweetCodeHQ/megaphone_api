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

  factory :entity_market do
    entity    { Entity.last }
    market  { Market.last }
  end

  factory :market do
    name { Faker::Beer.brand }
  end

  factory :market_keyword do
    market   { Market.last }
    keyword  { Keyword.last }
  end

  factory :keyword do
    word { Faker::Coffee.blend_name }
  end
end
