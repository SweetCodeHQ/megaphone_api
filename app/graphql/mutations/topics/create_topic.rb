module Mutations
  module Topics
    class CreateTopic < ::Mutations::BaseMutation
      argument :text,    String,      required: true
      argument :user_id, ID,          required: true

      type Types::TopicType

      def resolve(**attributes)
        Topic.create!(attributes)
      end
    end
  end
end
