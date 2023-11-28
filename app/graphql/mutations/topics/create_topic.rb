module Mutations
  module Topics
    class CreateTopic < ::Mutations::BaseMutation
      argument :text,    String,      required: true
      argument :user_id, ID,          required: true

      type Types::TopicType

      def resolve(**attributes)
        raise GraphQL::ExecutionError, "Incorrect execution." if context[:current_user] != @prepared_arguments[:user_id].to_i
        Topic.create!(attributes)
      end
    end
  end
end
