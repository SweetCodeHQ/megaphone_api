module Mutations
  module Users
    class UpdateUser < ::Mutations::BaseMutation
      argument :id,          ID,         required: false
      argument :email,       String,     required: false
      argument :is_admin,    Boolean,    required: false
      argument :is_blocked,   Boolean,    required: false
      argument :login_count, Integer, required: false
      argument :clicked_generate_count, Integer, required: false
      argument :industry, Integer, required: false
      argument :onboarded, Boolean, required: false

      argument :accepted_eula_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_privacy_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :saw_banner_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_cookies_on, GraphQL::Types::ISO8601DateTime, required: false

      type Types::UserType

      def resolve(**attributes)
        id = attributes[:id].to_i
        if attributes.keys == [:login_count]
          User.increment_counter(:login_count, id)
          User.find(id).reload
        elsif attributes.keys == [:clicked_generate_count]
          User.increment_counter(:clicked_generate_count, context[:current_user])
          User.find(context[:current_user]).reload
        elsif attributes.keys.include?(:is_admin) || attributes.keys.include?(:is_blocked)
          raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request]
          user = User.find(id)
          user.update!(attributes)
          user.reload
        else
          User.find(context[:current_user]).tap do |user|
            user.update!(attributes)
          end
        end
      end
    end
  end
end
