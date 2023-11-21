require 'rails_helper'

module Mutations
  module Banners
    RSpec.describe Banner, type: :request do
      describe 'resolve' do
        it 'updates a banner' do
          banner = create(:banner)

          post '/graphql', params: { query: g_query(id: banner.id) }, headers: { authorization: ENV['EAGLE_KEY'] }

          expect(banner.reload).to have_attributes(
            text: "New Text"
          )
        end

        it 'returns a banner' do
          banner2 = create(:banner)

          post '/graphql', params: { query: g_query(id: banner2.id) }, headers: { authorization: ENV['EAGLE_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateBanner]

          expect(data).to include(
            id: "#{ banner2.reload.id }",
            text: "New Text"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateBanner(input: {
                id: #{id}
                text: "New Text"
              }){
                id
                text
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          banner3 = create(:banner)

          post '/graphql', params: { query: g_query(id: 'not an id') }, headers: { authorization: ENV['EAGLE_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateBanner( input: {
                id: 'not an id'
              }) {
                id
                text
              }
            }
          GQL
        end
      end
    end
  end
end
