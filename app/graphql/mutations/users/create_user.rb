module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :email,     String,      required: true

      type Types::UserType

      def resolve(**attributes)
        user = User.find_by(email: attributes[:email])
        if context[:current_user] 
          raise GraphQL::ExecutionError, "Incorrect execution." unless context[:current_user] == user.id
          user
        else
          User.create!(attributes)
        end
      end
    end
  end
end