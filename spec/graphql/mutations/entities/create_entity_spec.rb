require 'rails_helper'

module Mutations
  module Entities
    RSpec.describe CreateEntity, type: :request do
      describe '.resolve' do
        it 'creates an entity' do

          expect do
            post '/graphql', params: { query: g_query(url: "widget.com", name: "Widget") }
          end.to change { Entity.count }.by(1)
        end

        it 'returns an admin user' do
          post '/graphql', params: { query: g_query(email: "wide.com", name: "Wide") }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createUser]

          expect(data).to include(
            id: "#{Entity.last.id}",

            url: "wide.com",
            name: "Wide"
          )
        end

        def g_query(url:, name:)
          <<~GQL
            mutation createEntity {
              createEntity( input: {
                url: "#{url}"
                name: "#{name}"
              } ){
                id
                url
                name
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors if email is not supplied' do
          entity = create(:entity)
          entity2 = create(:entity)

          post '/graphql', params: { query: g_query(name: "A name") }
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:errors)
        end

        def g_query(name:)
          <<~GQL
            mutation {
              createEntity( input: {
                name: #{name}
              } ){
                id
                url
                name
              }
            }
          GQL
        end
      end
    end
  end
end
