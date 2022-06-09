module Mutations
  module MarketKeywords
    class CreateMarketKeyword < ::Mutations::BaseMutation
      argument :market_id,    ID,     required: true
      argument :keyword_id,   ID,     required: true

      type Types::MarketKeywordType

      def resolve(**attributes)
        MarketKeyword.create!(attributes)
      end
    end
  end
end
