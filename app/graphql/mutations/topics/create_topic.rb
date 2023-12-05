module Mutations
  module Topics
    class CreateTopic < ::Mutations::BaseMutation
      argument :text,    String,      required: true

      type Types::TopicType

      def resolve(text:)
        raise GraphQL::ExecutionError, "Incorrect execution." if !context[:current_user]
        Topic.create!(text: text, user_id: context[:current_user])
      end
    end
  end
end
