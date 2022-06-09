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

    field :create_user_entity, mutation: Mutations::UserEntities::CreateUserEntity do
      description 'Create a user entity'
    end
  end
end
