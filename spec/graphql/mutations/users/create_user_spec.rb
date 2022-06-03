require 'rails_helper'

module Mutations
  module Users
    RSpec.describe CreateUser, type: :request do
      describe '.resolve' do
        it 'creates an admin user' do

          expect do
            post '/graphql', params: { query: g_query(email: "me@me.com", is_admin: true) }
          end.to change { User.count }.by(1)
        end

        it 'returns an admin user' do
          post '/graphql', params: { query: g_query(email: "you@u.com", is_admin: true) }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createUser]

          expect(data).to include(
            id: "#{User.last.id}",

            email: "you@u.com",
            isAdmin: true
          )
        end

        def g_query(email:, is_admin:)
          <<~GQL
            mutation createUser {
              createUser( input: {
                email: "#{email}"
                isAdmin: true
              } ){
                id
                email
                isAdmin
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors if email is not supplied' do
          user = create(:user)
          user2 = create(:user)

          post '/graphql', params: { query: g_query(is_admin: true) }
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:errors)
        end

        def g_query(is_admin:)
          <<~GQL
            mutation {
              createUser( input: {
                isAdmin: #{is_admin}
              } ){
                id
                email
                isAdmin
              }
            }
          GQL
        end
      end
    end
  end
end
