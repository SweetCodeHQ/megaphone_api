require 'rails_helper'

module Mutations
  module Topics
    RSpec.describe CreateTopic, type: :request do
      describe '.resolve' do
        it 'creates a topic' do
          user = create(:user)

          expect do
            post '/graphql', params: { query: g_query(text: "Topic Text", user_id: user.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          end.to change { Topic.count }.by(1)
        end

        it 'returns a topic' do
          user = create(:user)

          post '/graphql', params: { query: g_query(text: "More Topic Text", user_id: user.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createTopic]
          
          expect(data).to include(
            id: "#{Topic.last.id}",
            text: "More Topic Text"
          )
        end

        def g_query(text:, user_id:)
          <<~GQL
            mutation createTopic {
              createTopic( input: {
                text: "#{text}"
              } ){
                id
                text
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors if name is not supplied' do
          user = create(:user)
          topic = create(:topic)
          topic2 = create(:topic)

          post '/graphql', params: { query: g_query(name: true) }, headers: { authorization: ENV['MUTATION_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:errors)
        end

        def g_query(name:)
          <<~GQL
            mutation {
              createTopic( input: {
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
