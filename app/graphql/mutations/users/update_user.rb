module Mutations
  module Users
    class UpdateUser < ::Mutations::BaseMutation
      argument :id,          ID,         required: true
      argument :email,       String,     required: false
      argument :is_admin,    Boolean,    required: false
      argument :is_blocked,   Boolean,    required: false

      type Types::UserType

      def resolve(id:, **attributes)
        User.find(id).tap do |user|
          user.update!(attributes)
        end
      end
    end
  end
end
