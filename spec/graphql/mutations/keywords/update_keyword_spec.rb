require 'rails_helper'

module Mutations
  module Keywords
    RSpec.describe Keyword, type: :request do
      describe 'resolve' do
        it 'updates a keyword' do
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(id: keyword.id) }

          expect(keyword.reload).to have_attributes(
            word: "New Word"
          )
        end

        it 'returns a keyword' do
          keyword2 = create(:keyword)

          post '/graphql', params: { query: g_query(id: keyword2.id) }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateKeyword]

          expect(data).to include(
            id: "#{ keyword2.reload.id }",
            word: "New Word"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateKeyword(input: {
                id: #{id}
                word: "New Word"
              }){
                id
                word
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          keyword3 = create(:keyword)

          post '/graphql', params: { query: g_query(id: 'not an id') }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateKeyword( input: {
                id: 'not an id'
              }) {
                id
                word
              }
            }
          GQL
        end
      end
    end
  end
end
