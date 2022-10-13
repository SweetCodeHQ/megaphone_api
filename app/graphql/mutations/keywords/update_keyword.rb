module Mutations
  module Keywords
    class UpdateKeyword < ::Mutations::BaseMutation
      argument :id,        ID,         required: true

      type Types::KeywordType
# The only thing it updates is search_count
      def resolve(id:)
        Keyword.increment_counter(:search_count, id)
        Keyword.find(id)
      end
    end
  end
end
