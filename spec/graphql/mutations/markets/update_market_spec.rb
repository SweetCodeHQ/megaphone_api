require 'rails_helper'

module Mutations
  module Markets
    RSpec.describe Market, type: :request do
      describe 'resolve' do
        it 'updates a market' do
          market = create(:market)

          post '/graphql', params: { query: g_query(id: market.id) }

          expect(market.reload).to have_attributes(
            name: "New Name"
          )
        end

        it 'returns a market' do
          market2 = create(:market)

          post '/graphql', params: { query: g_query(id: market2.id) }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateMarket]

          expect(data).to include(
            id: "#{ market2.reload.id }",
            name: "New Name"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateMarket(input: {
                id: #{id}
                name: "New Name"
              }){
                id
                name
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          market3 = create(:market)

          post '/graphql', params: { query: g_query(id: 'not an id') }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateMarket( input: {
                id: 'not an id'
              }) {
                id
                name
              }
            }
          GQL
        end
      end
    end
  end
end
