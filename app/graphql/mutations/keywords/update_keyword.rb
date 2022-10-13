module Mutations
  module Keywords
    class UpdateKeyword < ::Mutations::BaseMutation
      argument :id, ID, required: false
      argument :search_count, Int, required: false
      argument :word,  String,  required: true

      type Types::KeywordType

      def resolve(word:)
        keyword = Keyword.find_by(word: word)
        Keyword.increment_counter(:search_count, keyword.id)
        keyword.reload
      end
    end
  end
end
