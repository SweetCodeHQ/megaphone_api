module Mutations
  module Keywords
    class UpdateKeyword < ::Mutations::BaseMutation
      argument :id,        ID,         required: true
      argument :word,      String,     required: false
      argument :search_count, Int,     required: false

      type Types::KeywordType
# The only thing it updates is search_count
      def resolve(id:)
        Keyword.increment_counter(:search_count, id)
        Keyword.find(id)
      end
    end
  end
end
