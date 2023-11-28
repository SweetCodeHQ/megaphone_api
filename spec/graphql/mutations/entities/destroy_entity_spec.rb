require 'rails_helper'

module Mutations
  module Entities
    RSpec.describe DestroyEntity, type: :request do
      describe 'resolve' do
        it 'removes an entity' do
          entity = create(:entity)
          user = create(:user, is_admin: true)

          expect do
            post '/graphql', params: { query: g_query(id: entity.id) }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
          end.to change { Entity.count }.by(-1)
        end

        it 'returns an entity' do
          entity = create(:entity)
          user = create(:user, is_admin: true)

          post '/graphql', params: { query: g_query(id: entity.id) }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)

          data = json[:data][:destroyEntity]
          expect(data).to include(
            id: "#{entity.id}"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyEntity( input: {
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
          entity = create(:entity)
          user = create(:user, is_admin: true)

          post '/graphql', params: { query: g_query(id: entity.id) }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyEntity( input: {
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
