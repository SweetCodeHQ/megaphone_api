require 'rails_helper'

module Mutations
  module Entities
    RSpec.describe CreateEntity, type: :request do
      describe '.resolve' do
        it 'creates an entity' do
          user = create(:user, is_admin: true)

          expect do
            post '/graphql', params: { query: g_query(url: "widget.com", name: "Widget") }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
          end.to change { Entity.count }.by(1)
        end

        it 'returns an entity' do
           user = create(:user, is_admin: true)

          post '/graphql', params: { query: g_query(url: "wide.com", name: "Wide") }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createEntity]

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
          user = create(:user, is_admin: true)
          entity = create(:entity)
          entity2 = create(:entity)

          post '/graphql', params: { query: g_query(name: "A name") }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
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
