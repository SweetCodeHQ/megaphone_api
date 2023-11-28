module Mutations
  module Topics
    class DestroyTopic < ::Mutations::BaseMutation
      argument :id, ID, required: true

      type Types::TopicType

      def resolve(id:)
        raise GraphQL::ExecutionError, "Incorrect execution." if context[:current_user] != Topic.find(id).user.id
        Topic.find(id).destroy
      end
    end
  end
end
