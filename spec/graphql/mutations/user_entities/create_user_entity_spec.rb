require 'rails_helper'

module Mutations
  module UserEntities
    RSpec.describe CreateUserEntity, type: :request do
      describe '.resolve' do
        it 'creates a user entity' do
          user   = create(:user)
          entity = create(:entity)

          expect do
            post '/graphql', params:
              { query: g_query(entity_id: entity.id)
              }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }
          end.to change { UserEntity.count }.by(1)
        end

        it 'returns a user entity' do
          user   = create(:user)
          entity = create(:entity)

          post '/graphql', params: { query: g_query(entity_id: entity.id) }, headers: { authorization: ENV['MUTATION_KEY'], user: user.id }

          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:createUserEntity]

          expect(data).to include(
            id: "#{UserEntity.first.id}"
          )
        end

        def g_query(entity_id:)
          <<~GQL
            mutation {
              createUserEntity( input: {
                entityId: "#{entity_id}"
              } ){
                id
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors' do
          user   = create(:user)
          entity = create(:entity)

          post '/graphql', params: { query: g_query(user_id: user.id, entity_id: entity.id) }, headers: { authorization: ENV['MUTATION_KEY'] }

          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(user_id:, entity_id:)
          <<~GQL
            mutation {
              createUserEntity( input: {
                userId: "#{user_id}"
              } ){
                id
              }
            }
          GQL
        end
      end
    end
  end
end
