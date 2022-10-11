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
              { query: g_query(user_id: user.id, keyword_id: keyword.id)
              }
          end.to change { UserKeyword.count }.by(1)
        end

        it 'returns a user keyword' do
          user = create(:user)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(user_id: user.id, keyword_id: keyword.id) }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createUserKeyword]

          expect(data).to include(
            id: "#{UserKeyword.first.id}"
          )
        end

        def g_query(user_id:, keyword_id:)
          <<~GQL
            mutation {
              createUserKeyword( input: {
                userId: "#{user_id}"
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

          post '/graphql', params: { query: g_query(user_id: user.id, keyword_id: keyword.id) }

          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(user_id:, keyword_id:)
          <<~GQL
            mutation {
              createUserEntity( input: {
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
