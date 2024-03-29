require 'rails_helper'

module Mutations
  module UserKeywords
    RSpec.describe CreateUserKeyword, type: :request do
      describe '.resolve' do
        it 'creates a user keyword' do
          user  = create(:user)
          keyword = create(:keyword)

          expect do
            post '/graphql', params:
              { query: g_query(keyword_id: keyword.id)
              }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          end.to change { UserKeyword.count }.by(1)
        end

        it 'returns a user keyword' do
          user = create(:user)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(keyword_id: keyword.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createUserKeyword]

          expect(data).to include(
            id: "#{UserKeyword.first.id}"
          )
        end

        it 'does not create a new user keyword if it already exists' do
          user  = create(:user)
          keyword = create(:keyword)

          expect do
            post '/graphql', params:
              { query: g_query(keyword_id: keyword.id)
              }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

            post '/graphql', params:
              { query: g_query(keyword_id: keyword.id)
              }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          end.to change { UserKeyword.count }.by(1)
        end

        it 'returns a user keyword if it already exists' do
          user = create(:user)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(keyword_id: keyword.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          post '/graphql', params: { query: g_query(keyword_id: keyword.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createUserKeyword]

          expect(data).to include(
            id: "#{UserKeyword.first.id}"
          )
        end

        def g_query(keyword_id:)
          <<~GQL
            mutation {
              createUserKeyword( input: {
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
          user  = create(:user)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(user_id: user.id, word: keyword.word) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(user_id:, word:)
          <<~GQL
            mutation {
              createUserKeyword( input: {
                userId: "#{user_id}"
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
