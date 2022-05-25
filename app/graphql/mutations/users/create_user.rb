module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :email,     String,      required: true
      argument :is_admin,  Boolean,     required: false

      type Types::UserType

      def resolve(**attributes)
        User.create!(attributes)
      end
    end
  end
end
