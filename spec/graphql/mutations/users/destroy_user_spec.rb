require 'rails_helper'

module Mutations
  module Users
    RSpec.describe DestroyUser, type: :request do
      describe 'resolve' do
        it 'removes a user' do
          user = create(:user)
          topic = create(:topic, user: user)

          expect do
            post '/graphql', params: { query: g_query(id: user.id) }, headers: { authorization: ENV['MUTATION_KEY'] }
          end.to change { User.count }.by(-1)
        end

        it 'returns a user' do
          user = create(:user)
          topic = create(:topic, user: user)

          post '/graphql', params: { query: g_query(id: user.id) }, headers: { authorization: ENV['MUTATION_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:destroyUser]

          expect(data).to include(
            id: "#{user.id}"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyUser( input: {
                id: #{id}
              }) {
                id
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          user = create(:user)
          topic = create(:topic, user: user)

          post '/graphql', params: { query: g_query(id: topic.id) }, headers: { authorization: ENV['MUTATION_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyUser( input: {
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
