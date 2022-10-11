module Mutations
  module UserKeywords
    class CreateUserKeyword < ::Mutations::BaseMutation
      argument :user_id,    ID, required: true
      argument :keyword_id, ID, required: true

      type Types::MarketKeywordType

      def resolve(**attributes)
        UserKeyword.create!(attributes)
      end
    end
  end
end
