module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :email,     String,      required: true

      type Types::UserType

      def resolve(**attributes)
        User.create!(attributes)
      end
    end
  end
end
