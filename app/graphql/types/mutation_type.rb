module Types
  class MutationType < Types::BaseObject

    field :create_user, mutation: Mutations::Users::CreateUser do
      description 'Create a user'
    end

    field :create_entity, mutation: Mutations::Entities::CreateEntity do
      description 'Create an entity'
    end
  end
end
