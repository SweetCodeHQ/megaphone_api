module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :email,     String,      required: true

      type Types::UserType

      def resolve(**attributes)
        user = User.find_by(email: attributes[:email])
        user ? user : User.create!(attributes)
      end
    end
  end
end