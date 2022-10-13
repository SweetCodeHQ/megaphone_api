module Mutations
  module Keywords
    class UpdateKeyword < ::Mutations::BaseMutation
      argument :id,        ID,         required: true
      argument :word,      String,     required: false
      argument :search_count, Int,     required: false

      type Types::KeywordType

      def resolve(id:, **attributes)
        Keyword.find(id).tap do |keyword|
          keyword.update!(attributes)
        end
      end
    end
  end
end
