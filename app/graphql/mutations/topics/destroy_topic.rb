module Mutations
  module Topics
    class DestroyTopic < ::Mutations::BaseMutation
      argument :id, Integer, required: true

      type Types::TopicType

      def resolve(id:)
        Topic.find(id).destroy
      end
    end
  end
end
