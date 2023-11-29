require 'rails_helper'

module Mutations
  module Users
    RSpec.describe User, type: :request do
      describe 'resolve' do
        it 'updates a user' do
          user = create(:user)

          post '/graphql', params: { query: g_query(id: user.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          expect(user.reload).to have_attributes(
            industry: "monitoring_and_observability"
          )
        end

        it 'updates another user when the user is an admin' do
          user = create(:user)
          user2 = create(:user, is_admin: true)

          post '/graphql', params: { query: g_query_b(id: user.id) }, headers: { authorization: ENV['EAGLE_KEY'], user: user2.id }

          expect(user.reload).to have_attributes(
            is_admin: true
          )
        end

        it 'returns a user' do
          user3 = create(:user)

          post '/graphql', params: { query: g_query(id: user3.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user3.id }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateUser]

          expect(data).to include(
            id: "#{ user3.reload.id }",
            industry: 3
          )
        end

        it "it updates a user loginCount" do
          user = create(:user)

          post '/graphql', params: { query: g_query2(id: user.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          expect(user.reload).to have_attributes(
            login_count: 1
          )
        end

        it "it updates a user clickedGenerateCount" do
          user = create(:user)

          post '/graphql', params: { query: g_query3(id: user.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          expect(user.reload).to have_attributes(
            clicked_generate_count: 1
          )

        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateUser(input: {
                id: #{id}
                industry: 3
              }){
                id
                isAdmin
                industry
              }
            }
          GQL
        end

        def g_query_b(id:)
          <<~GQL
            mutation {
              updateUser(input: {
                id: #{id}
                isAdmin: true
                industry: 3
              }){
                id
                isAdmin
                industry
              }
            }
          GQL
        end

        def g_query2(id:)
          <<~GQL
            mutation {
              updateUser(input: {
                id: #{id}
                loginCount: 1
              }){
                id
                loginCount
              }
            }
          GQL
        end

        def g_query3(id:)
          <<~GQL
            mutation {
              updateUser(input: {
                id: #{id}
                clickedGenerateCount: 1
              }){
                id
                clickedGenerateCount
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          user3 = create(:user)

          post '/graphql', params: { query: g_query(id: 'not an id') }, headers: { authorization: ENV['MUTATION_KEY'], user: user3.id }
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
