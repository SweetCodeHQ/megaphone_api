module Mutations
  module EntityMarkets
    class CreateEntityMarket < ::Mutations::BaseMutation
      argument :market_id,    ID,     required: true
      argument :entity_id,    ID,     required: true

      type Types::EntityMarketType

      def resolve(**attributes)
        EntityMarket.create!(attributes)
      end
    end
  end
end
