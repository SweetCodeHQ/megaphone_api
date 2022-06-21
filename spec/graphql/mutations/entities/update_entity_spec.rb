require 'rails_helper'

module Mutations
  module Entities
    RSpec.describe Entity, type: :request do
      describe 'resolve' do
        it 'updates an entity' do
          entity = create(:entity)

          post '/graphql', params: { query: g_query(id: entity.id) }

          expect(entity.reload).to have_attributes(
            name: "New Name"
          )
        end

        it 'returns an entity' do
          entity2 = create(:entity)

          post '/graphql', params: { query: g_query(id: entity2.id) }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateEntity]

          expect(data).to include(
            id: "#{ entity2.reload.id }",
            name: "New Name"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateEntity(input: {
                id: #{id}
                name: "New Name"
              }){
                id
                name
                url
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do
          entity3 = create(:entity)

          post '/graphql', params: { query: g_query(id: 'not an id') }
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
