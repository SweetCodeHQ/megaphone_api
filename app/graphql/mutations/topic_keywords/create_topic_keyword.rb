module Mutations
  module TopicKeywords
    class CreateTopicKeyword < ::Mutations::BaseMutation
      argument :topic_id,    ID,     required: true
      argument :keyword_id,   ID,     required: true

      type Types::TopicKeywordType

      def resolve(**attributes)
        TopicKeyword.create!(attributes)
      end
    end
  end
end
