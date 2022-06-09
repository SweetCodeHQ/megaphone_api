module Mutations
  module Markets
    class CreateMarket < ::Mutations::BaseMutation
      argument :name,    String,      required: true

      type Types::MarketType

      def resolve(**attributes)
        Market.create!(attributes)
      end
    end
  end
end
