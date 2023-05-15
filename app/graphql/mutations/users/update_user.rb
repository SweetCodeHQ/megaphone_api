module Mutations
  module Users
    class UpdateUser < ::Mutations::BaseMutation
      argument :id,          ID,         required: true
      argument :email,       String,     required: false
      argument :is_admin,    Boolean,    required: false
      argument :is_blocked,   Boolean,    required: false
      argument :login_count, Integer, required: false
      argument :clicked_generate_count, Integer, required: false
      argument :industry, Integer, required: false
      argument :onboarded, Boolean, required: false
      
      type Types::UserType

      def resolve(id:, **attributes)
        if attributes.keys.include?(:login_count)
          User.increment_counter(:login_count, id)
          User.find(id).reload
        elsif attributes.keys.include?(:clicked_generate_count)
          User.increment_counter(:clicked_generate_count, id)
          User.find(id).reload
        else
          User.find(id).tap do |user|
            user.update!(attributes)
          end
        end
      end
    end
  end
end
