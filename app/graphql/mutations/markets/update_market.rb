module Mutations
  module Markets
    class UpdateMarket < ::Mutations::BaseMutation
      argument :id,              ID,                          required: true
      argument :name,            String,                      required: false

      type Types::MarketType

      def resolve(id:, **attributes)
        Market.find(id).tap do |market|
          market.update!(attributes)
        end
      end
    end
  end
end
