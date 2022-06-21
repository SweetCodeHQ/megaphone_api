module Types
  class MutationType < Types::BaseObject

    field :create_user, mutation: Mutations::Users::CreateUser do
      description 'Create a user'
    end

    field :create_entity, mutation: Mutations::Entities::CreateEntity do
      description 'Create an entity'
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

    field :update_entity, mutation: Mutations::Entities::UpdateEntity do
      description 'Update an entity'
    end
  end
end
