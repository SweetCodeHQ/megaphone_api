module Mutations
  module Keywords
    class CreateKeyword < ::Mutations::BaseMutation
      argument :word,    String,      required: true

      type Types::KeywordType

      def resolve(**attributes)
        if Keyword.find_by(word: attributes[:word])
          Keyword.find_by(word: attributes[:word])
        else
          Keyword.create!(attributes)
        end
      end
    end
  end
end
