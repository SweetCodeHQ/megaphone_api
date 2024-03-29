require 'rails_helper'

module Mutations
  module Topics
    RSpec.describe DestroyTopic, type: :request do
      describe 'resolve' do
        it 'removes a topic' do
          user = create(:user)
          topic = create(:topic, user: user)

          expect do
            post '/graphql', params: { query: g_query(id: topic.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          end.to change { Topic.count }.by(-1)
        end

        it 'returns a topic' do
          user = create(:user)
          topic = create(:topic, user: user)

          post '/graphql', params: { query: g_query(id: topic.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:destroyTopic]

          expect(data).to include(
            id: "#{topic.id}"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyTopic( input: {
                id: #{id}
              }) {
                id
              }
            }
          GQL
        end

        it "should also destroy the associated abstract" do
          user = create(:user)
          topic1 = create(:topic, user: user)
          topic2 = create(:topic, user: user)
          abstract1 = create(:abstract, topic: topic1)
          abstract2 = create(:abstract, topic: topic2)

          post '/graphql', params: { query: g_query(id: topic1.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          expect(User.all.size).to eq(1)
          expect(Topic.all.size).to eq(1)
          expect(Abstract.all.size).to eq(1)

          expect { Topic.find(topic1.id) }.to raise_error(ActiveRecord::RecordNotFound)
          expect { Abstract.find(abstract1.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          user = create(:user)
          topic = create(:topic, user: user)

          post '/graphql', params: { query: g_query(id: topic.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyTopic( input: {
                id: 'not an id'
              }) {
                id
              }
            }
          GQL
        end
      end
    end
  end
end
