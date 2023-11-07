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
              }, headers: { authorization: ENV['MUTATION_KEY'] }
          end.to change { TopicKeyword.count }.by(1)
        end

        it 'returns a topic keyword' do
          user = create(:user)
          topic = create(:topic)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(topic_id: topic.id, keyword_id: keyword.id) }, headers: { authorization: ENV['MUTATION_KEY'] }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createTopicKeyword]

          expect(data).to include(
            id: "#{TopicKeyword.first.id}"
          )
        end

        it 'does not create a new topic keyword if it already exists' do
          user  = create(:user)
          topic = create(:topic)
          keyword = create(:keyword)

          expect do
            post '/graphql', params:
              { query: g_query(keyword_id: keyword.id, topic_id: topic.id)
              }, headers: { authorization: ENV['MUTATION_KEY'] }

            post '/graphql', params:
              { query: g_query(keyword_id: keyword.id, topic_id: topic.id)
              }, headers: { authorization: ENV['MUTATION_KEY'] }
          end.to change { TopicKeyword.count }.by(1)
        end

        it 'returns a topic keyword if it already exists' do
          user = create(:user)
          topic = create(:topic)
          keyword = create(:keyword)

          post '/graphql', params: { query: g_query(keyword_id: keyword.id, topic_id: topic.id) }, headers: { authorization: ENV['MUTATION_KEY'] }

          post '/graphql', params: { query: g_query(keyword_id: keyword.id, topic_id: topic.id) }, headers: { authorization: ENV['MUTATION_KEY'] }

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
    end
  end
end
