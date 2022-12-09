require 'rails_helper'

module Mutations
  module Abstracts
    RSpec.describe CreateAbstract, type: :request do
      describe '.resolve' do
        it 'creates an abstract' do
          user =      create(:user)
          topic =     create(:topic)
          abstract =  create(:abstract)

          expect do
            post '/graphql', params: { query: g_query(text: "I am an abstract with a great amount of text", topic_id: topic.id) }
          end.to change { Abstract.count }.by(1)
        end

        it 'returns an abstract' do
          user =      create(:user)
          topic =     create(:topic)
          abstract =  create(:abstract)
          post '/graphql', params: { query: g_query(text: "Something wordy", topic_id: topic.id) }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createAbstract]

          expect(data).to include(
            id: "#{Abstract.last.id}",

            text: "Something wordy",
            topicId: topic.id.to_s
          )
        end

        def g_query(text:, topic_id:)
          <<~GQL
            mutation createAbstract {
              createAbstract( input: {
                topicId: "#{topic_id}"
                text: "#{text}"
              } ){
                id
                topicId
                text
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors if email is not supplied' do
          user = create(:user)
          topic = create(:topic)

          post '/graphql', params: { query: g_query(text: "Texty") }
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:errors)
        end

        def g_query(text:)
          <<~GQL
            mutation {
              createAbstract( input: {
                text: #{text}
              } ){
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
