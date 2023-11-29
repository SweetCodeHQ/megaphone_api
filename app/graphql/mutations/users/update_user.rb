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

      argument :accepted_eula_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_privacy_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :saw_banner_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_cookies_on, GraphQL::Types::ISO8601DateTime, required: false

      type Types::UserType

      def resolve(id:, **attributes)
        if attributes.keys == [:login_count]
          User.increment_counter(:login_count, id)
          User.find(id).reload
        elsif attributes.keys == [:clicked_generate_count]
          User.increment_counter(:clicked_generate_count, id)
          User.find(id).reload
        elsif attributes.keys.include?(:is_admin)
          raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request]
          user = User.find(id)
          user.update!(is_admin: true)
          user.reload
        else
          raise GraphQL::ExecutionError, "Incorrect execution." unless context[:current_user] == id.to_i
          User.find(id).tap do |user|
            user.update!(attributes)
          end
        end
      end
    end
  end
end
