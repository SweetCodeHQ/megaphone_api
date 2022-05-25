module Types
  class MutationType < Types::BaseObject

    field :create_user, mutation: Mutations::Users::CreateUser do
      description 'Create a user'
    end
  end
end
