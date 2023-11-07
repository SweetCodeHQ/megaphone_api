require 'rails_helper'

module Mutations
  module Keywords
    RSpec.describe CreateKeyword, type: :request do
      describe '.resolve' do
        it 'creates a keyword' do

          expect do
            post '/graphql', params: { query: g_query(word: "Widget") }, headers: { authorization: ENV['MUTATION_KEY'] }
          end.to change { Keyword.count }.by(1)
        end

        it 'returns a keyword' do
          post '/graphql', params: { query: g_query(word: "Wide") }, headers: { authorization: ENV['MUTATION_KEY'] }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createKeyword]

          expect(data).to include(
            id: "#{Keyword.last.id}",
            word: "Wide"
          )
        end

        it 'returns a keyword if it already exists' do

          expect do
            post '/graphql', params: { query: g_query(word: "Widget") }, headers: { authorization: ENV['MUTATION_KEY'] }
          end.to change { Keyword.count }.by(1)
        end

        it 'returns the keyword if it already exists' do
          post '/graphql', params: { query: g_query(word: "Wide") }, headers: { authorization: ENV['MUTATION_KEY'] }

          post '/graphql', params: { query: g_query(word: "Widget") }, headers: { authorization: ENV['MUTATION_KEY'] }

          post '/graphql', params: { query: g_query(word: "Wide") }, headers: { authorization: ENV['MUTATION_KEY'] }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createKeyword]

          expect(data).to include(
            id: "#{Keyword.first.id}",
            word: "Wide"
          )
        end

        def g_query(word:)
          <<~GQL
            mutation createKeyword {
              createKeyword( input: {
                word: "#{word}"
              } ){
                id
                word
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors if word is not supplied' do
          keyword = create(:keyword)
          keyword2 = create(:keyword)

          post '/graphql', params: { query: g_query(word: true) }, headers: { authorization: ENV['MUTATION_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:errors)
        end

        def g_query(word:)
          <<~GQL
            mutation {
              createKeyword( input: {
                word: #{word}
              } ){
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
