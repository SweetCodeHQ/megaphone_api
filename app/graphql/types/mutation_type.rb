module Types
  class MutationType < Types::BaseObject

    field :create_user, mutation: Mutations::Users::CreateUser do
      description 'Create a user'
    end

    field :destroy_user, mutation: Mutations::Users::DestroyUser do
      description 'Destroy a user'
    end

    field :create_entity, mutation: Mutations::Entities::CreateEntity do
      description 'Create an entity'
    end

    field :destroy_entity, mutation: Mutations::Entities::DestroyEntity do
      description 'Destroy an entity'
    end

    field :create_market, mutation: Mutations::Markets::CreateMarket do
      description 'Create a market'
    end

    field :create_keyword, mutation: Mutations::Keywords::CreateKeyword do
      description 'Create a keyword'
    end

    field :create_user_entity, mutation: Mutations::UserEntities::CreateUserEntity do
      description 'Create a user entity'
    end

    field :create_entity_market, mutation: Mutations::EntityMarkets::CreateEntityMarket do
      description 'Create an entity market'
    end

    field :create_market_keyword, mutation: Mutations::MarketKeywords::CreateMarketKeyword do
      description 'Create a market keyword'
    end

    field :create_topic, mutation: Mutations::Topics::CreateTopic do
      description 'Create a topic'
    end

    field :update_entity, mutation: Mutations::Entities::UpdateEntity do
      description 'Update an entity'
    end

    field :update_user, mutation: Mutations::Users::UpdateUser do
      description 'Update a user'
    end

    field :update_market, mutation: Mutations::Markets::UpdateMarket do
      description 'Update a market'
    end

    field :update_keyword, mutation: Mutations::Keywords::UpdateKeyword do
      description 'Update a keyword'
    end

    field :update_topic, mutation: Mutations::Topics::UpdateTopic do
      description 'Update a topic'
    end

    field :destroy_topic, mutation: Mutations::Topics::DestroyTopic do
      description 'Destroy a topic'
    end

    field :create_user_keyword, mutation: Mutations::UserKeywords::CreateUserKeyword do
      description 'Create a user keyword'
    end

    field :create_topic_keyword, mutation: Mutations::TopicKeywords::CreateTopicKeyword do
      description 'Create a topic keyword'
    end

    field :create_abstract, mutation: Mutations::Abstracts::CreateAbstract do
      description 'Create an abstract'
    end

    field :update_abstract, mutation: Mutations::Abstracts::UpdateAbstract do
      description 'Update an abstract'
    end

    field :destroy_abstract, mutation: Mutations::Abstracts::DestroyAbstract do
      description 'Destroy an abstract'
    end

    field :create_banner, mutation: Mutations::Banners::CreateBanner do
      description 'Create a banner'
    end

    field :update_banner, mutation: Mutations::Banners::UpdateBanner do
      description 'Update a banner'
    end
  end
end
