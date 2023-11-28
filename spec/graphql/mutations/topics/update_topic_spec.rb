require 'rails_helper'

module Mutations
  module Topics
    RSpec.describe Topic, type: :request do
      describe 'resolve' do
        it 'updates a topic' do
          user = create(:user)
          topic = create(:topic)

          post '/graphql', params: { query: g_query(id: topic.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          expect(topic.reload).to have_attributes(
            text: "New Text",
            submitted: true
          )
        end

        it 'returns a topic' do
          user = create(:user)
          topic2 = create(:topic)

          post '/graphql', params: { query: g_query(id: topic2.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateTopic]

          expect(data).to include(
            id: "#{ topic2.reload.id }",
            text: "New Text",
            submitted: true
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateTopic(input: {
                id: #{id}
                text: "New Text"
                submitted: true
              }){
                id
                text
                submitted
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          user = create(:user)
          topic3 = create(:topic)

          post '/graphql', params: { query: g_query(id: 'not an id') }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateTopic( input: {
                id: 'not an id'
              }) {
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
