require 'rails_helper'

module Mutations
  module Keywords
    RSpec.describe Keyword, type: :request do
      describe 'resolve' do
        it 'updates a keyword search_count' do
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(word: keyword.word) }
          
          expect(keyword.reload).to have_attributes(
            search_count: 2
          )
        end

        it 'returns a keyword' do
          keyword2 = create(:keyword)

          post '/graphql', params: { query: g_query(word: keyword2.word) }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateKeyword]

          expect(data).to include(
            id: "#{ keyword2.reload.id }",
            searchCount: 2
          )
        end

        def g_query(word:)
          <<~GQL
            mutation {
              updateKeyword(input: {
                word: "#{word}"
              }){
                id
                searchCount
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          keyword3 = create(:keyword)

          post '/graphql', params: { query: g_query(word: 'not an id') }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(word:)
          <<~GQL
            mutation {
              updateKeyword(input: {
                word: 5
              }){
                id
                searchCount
              }
            }
          GQL
        end
      end
    end
  end
end
