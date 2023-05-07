require 'rails_helper'

module Mutations
  module TopicKeywords
    RSpec.describe CreateTopicKeyword, type: :request do
      describe '.resolve' do
        it 'creates a topic keyword' do
          user  = create(:user)
          topic = create(:topic)
          keyword = create(:keyword)

          expect do
            post '/graphql', params:
              { query: g_query(topic_id: topic.id, keyword_id: keyword.id)
              }
          end.to change { TopicKeyword.count }.by(1)
        end

        it 'returns a topic keyword' do
          user = create(:user)
          topic = create(:topic)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(topic_id: topic.id, keyword_id: keyword.id) }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createTopicKeyword]

          expect(data).to include(
            id: "#{TopicKeyword.first.id}"
          )
        end

        def g_query(topic_id:, keyword_id:)
          <<~GQL
            mutation {
              createTopicKeyword( input: {
                topicId: "#{topic_id}"
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
          topic = create(:topic)

          post '/graphql', params: { query: g_query(user_id: topic.id, keyword_id: keyword.id) }

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
