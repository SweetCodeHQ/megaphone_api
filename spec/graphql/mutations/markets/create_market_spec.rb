require 'rails_helper'

module Mutations
  module Markets
    RSpec.describe CreateMarket, type: :request do
      describe '.resolve' do
        it 'creates a market' do

          expect do
            post '/graphql', params: { query: g_query(name: "Widget") }
          end.to change { Market.count }.by(1)
        end

        it 'returns a market' do
          post '/graphql', params: { query: g_query(name: "Wide") }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createMarket]

          expect(data).to include(
            id: "#{Market.last.id}",
            name: "Wide"
          )
        end

        def g_query(name:)
          <<~GQL
            mutation createMarket {
              createMarket( input: {
                name: "#{name}"
              } ){
                id
                name
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors if name is not supplied' do
          market = create(:market)
          market2 = create(:market)

          post '/graphql', params: { query: g_query(name: true) }
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:errors)
        end

        def g_query(name:)
          <<~GQL
            mutation {
              createMarket( input: {
                name: #{name}
              } ){
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
