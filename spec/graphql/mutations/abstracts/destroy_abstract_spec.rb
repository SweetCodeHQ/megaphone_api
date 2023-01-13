require 'rails_helper'

module Mutations
  module Abstracts
    RSpec.describe DestroyAbstract, type: :request do
      describe 'resolve' do
        it 'removes an abstract' do
          user = create(:user)
          topic = create(:topic, user: user)
          abstract = create(:abstract)

          expect do
            post '/graphql', params: { query: g_query(id: abstract.id) }
          end.to change { Abstract.count }.by(-1)
        end

        it 'returns an abstract' do
          user = create(:user)
          topic = create(:topic, user: user)
          abstract = create(:abstract)

          post '/graphql', params: { query: g_query(id: abstract.id) }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:destroyAbstract]
          expect(data).to include(
            id: "#{abstract.id}"
          )
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyAbstract( input: {
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
          abstract = create(:abstract)

          post '/graphql', params: { query: g_query(id: abstract.id) }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              destroyAbstract( input: {
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
