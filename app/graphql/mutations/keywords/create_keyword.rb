module Mutations
  module Keywords
    class CreateKeyword < ::Mutations::BaseMutation
      argument :word,    String,      required: true

      type Types::KeywordType

      def resolve(**attributes)
        Keyword.create!(attributes)
      end
    end
  end
end
