require 'rails_helper'

module Mutations
  module Entities
    RSpec.describe Entity, type: :request do
      describe 'resolve' do
        it 'updates an entity' do
          entity = create(:entity)
          user = create(:user, is_admin: true)

          post '/graphql', params: { query: g_query(id: entity.id) }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }

          expect(entity.reload).to have_attributes(
            credits: 10
          )
        end

        it 'returns an entity' do
          entity2 = create(:entity, request_in_progress: true)
          user = create(:user, is_admin: true)

          post '/graphql', params: { query: g_query(id: entity2.id) }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateEntity]

          expect(data).to include(
            id: "#{ entity2.reload.id }",
            credits: 10,
            requestInProgress: false
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateEntity(input: {
                id: #{id}
                credits: 10
              }){
                id
                credits
                url
                requestInProgress
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          user = create(:user)
          entity3 = create(:entity)

          post '/graphql', params: { query: g_query(id: 'not an id') }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateEntity( input: {
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
