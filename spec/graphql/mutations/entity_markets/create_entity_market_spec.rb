require 'rails_helper'

module Mutations
  module EntityMarkets
    RSpec.describe CreateEntityMarket, type: :request do
      describe '.resolve' do
        it 'creates a user entity' do
          market = create(:market)
          entity = create(:entity)

          expect do
            post '/graphql', params:
              { query: g_query(market_id: market.id, entity_id: entity.id)
              }, headers: { authorization: ENV['MUTATION_KEY'] }
          end.to change { EntityMarket.count }.by(1)
        end

        it 'returns a user entity' do
          market = create(:market)
          entity = create(:entity)

          post '/graphql', params: { query: g_query(market_id: market.id, entity_id: entity.id) }, headers: { authorization: ENV['MUTATION_KEY'] }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createEntityMarket]

          expect(data).to include(
            id: "#{EntityMarket.first.id}"
          )
        end

        def g_query(market_id:, entity_id:)
          <<~GQL
            mutation {
              createEntityMarket( input: {
                marketId: "#{market_id}"
                entityId: "#{entity_id}"
              } ){
                id
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors' do
          market   = create(:market)
          entity = create(:entity)

          post '/graphql', params: { query: g_query(market_id: market.id, entity_id: entity.id) }, headers: { authorization: ENV['MUTATION_KEY'] }

          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(market_id:, entity_id:)
          <<~GQL
            mutation {
              createEntityMarket( input: {
                marketId: "#{market_id}"
              } ){
                id
              }
            }
          GQL
        end
      end
    end
  end
end
