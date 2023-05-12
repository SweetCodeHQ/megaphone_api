module Mutations
  module TopicKeywords
    class CreateTopicKeyword < ::Mutations::BaseMutation
      argument :topic_id,    ID,     required: true
      argument :keyword_id,   ID,     required: true

      type Types::TopicKeywordType

      def resolve(**attributes)
        topic_keyword = TopicKeyword.where(topic_id: attributes[:topic_id]).where(keyword_id: attributes[:keyword_id]).first

        topic_keyword ?
        topic_keyword :
        TopicKeyword.create!(attributes)
      end
    end
  end
end
