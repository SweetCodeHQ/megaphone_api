require 'rails_helper'

module Mutations
  module MarketKeywords
    RSpec.describe CreateMarketKeyword, type: :request do
      describe '.resolve' do
        it 'creates a market keyword' do
          market  = create(:market)
          keyword = create(:keyword)

          expect do
            post '/graphql', params:
              { query: g_query(market_id: market.id, keyword_id: keyword.id)
              }
          end.to change { MarketKeyword.count }.by(1)
        end

        it 'returns a market keyword' do
          market = create(:market)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(market_id: market.id, keyword_id: keyword.id) }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createMarketKeyword]

          expect(data).to include(
            id: "#{MarketKeyword.first.id}"
          )
        end

        def g_query(market_id:, keyword_id:)
          <<~GQL
            mutation {
              createMarketKeyword( input: {
                marketId: "#{market_id}"
                keywordId: "#{keyword_id}"
              } ){
                id
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors' do
          market  = create(:market)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(market_id: market.id, keyword_id: keyword.id) }

          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(market_id:, keyword_id:)
          <<~GQL
            mutation {
              createUserEntity( input: {
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
