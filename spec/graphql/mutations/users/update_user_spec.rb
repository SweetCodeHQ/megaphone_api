require 'rails_helper'

module Mutations
  module Users
    RSpec.describe User, type: :request do
      describe 'resolve' do
        it 'updates a user' do
          user = create(:user)

          post '/graphql', params: { query: g_query(id: user.id) }

          expect(user.reload).to have_attributes(
            email: "New Email"
          )
        end

        it 'returns a user' do
          user2 = create(:user)

          post '/graphql', params: { query: g_query(id: user2.id) }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateUser]

          expect(data).to include(
            id: "#{ user2.reload.id }",
            email: "New Email"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateUser(input: {
                id: #{id}
                email: "New Email"
              }){
                id
                email
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          user3 = create(:user)

          post '/graphql', params: { query: g_query(id: 'not an id') }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateUser( input: {
                id: 'not an id'
              }) {
                id
                email
              }
            }
          GQL
        end
      end
    end
  end
end
