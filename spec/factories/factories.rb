FactoryBot.define do

  factory :user do
    email       { Faker::Internet.email }

    factory :admin_user do
      is_admin  { true }
    end
  end

  factory :entity do
    url         { Faker::Internet.unique.domain_name }
  end

  factory :user_entity do
    user    { User.last }
    entity  { Entity.last }
  end

  factory :user_keyword do
    user     { User.last }
    keyword  { Keyword.last }
  end

  factory :entity_market do
    entity  { Entity.last }
    market  { Market.last }
  end

  factory :market do
    name { Faker::Beer.unique.brand }
  end

  factory :market_keyword do
    market   { Market.last }
    keyword  { Keyword.last }
  end

  factory :topic_keyword do
    keyword { Keyword.last }
    topic   { Topic.last }
  end

  factory :keyword do
    word { Faker::Coffee.unique.blend_name }
  end

  factory :topic do
    user { User.last }
    text { Faker::Alphanumeric.unique.alpha(number: 10) }
  end

  factory :abstract do
    topic { Topic.last }
    text { Faker::Lorem.paragraph(sentence_count: 10)}
  end

  factory :banner do
    purpose { (0..3).to_a.sample }
    link { Faker::Internet.domain_name }
    text { Faker::DcComics.title }
  end
end
