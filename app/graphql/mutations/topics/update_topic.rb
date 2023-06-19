module Mutations
  module Topics
    class UpdateTopic < ::Mutations::BaseMutation
      argument :id,      ID,         required: true
      argument :text,    String,     required: false
      argument :submitted, Boolean, required: false
      argument :content_type, Integer, required: false

      type Types::TopicType

      def resolve(id:, **attributes)
        Topic.find(id).tap do |topic|
          topic.update!(attributes)
        end
      end
    end
  end
end
