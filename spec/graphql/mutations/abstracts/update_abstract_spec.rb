require 'rails_helper'

module Mutations
  module Abstracts
    RSpec.describe Abstract, type: :request do
      describe 'resolve' do
        it 'updates an abstract' do
          user = create(:user)
          topic = create(:topic)
          abstract = create(:abstract)

          post '/graphql', params: { query: g_query(abstract_id: abstract.id) }, headers: { authorization: ENV['MUTATION_KEY'] }

          expect(abstract.reload).to have_attributes(
            text: "Very new text"
          )
        end

        it 'returns an abstract' do
          user = create(:user)
          topic = create(:topic)
          abstract = create(:abstract)

          post '/graphql', params: { query: g_query(abstract_id: abstract.id) }, headers: { authorization: ENV['MUTATION_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)
          data = json[:data][:updateAbstract]

          expect(data).to include(
            id: "#{ abstract.reload.id }",
            text: "Very new text"
          )
        end

        def g_query(abstract_id:)
          <<~GQL
            mutation {
              updateAbstract(input: {
                id: #{abstract_id}
                text: "Very new text"
              }){
                id
                text
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns with errors' do

          post '/graphql', params: { query: g_query(id: 'not an id') }, headers: { authorization: ENV['MUTATION_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)
          expect(json).to have_key(:errors)
        end

        def g_query(id:)
          <<~GQL
            mutation {
              updateAbstract( input: {
                id: 'not an id'
              }) {
                id
                text
              }
            }
          GQL
        end
      end
    end
  end
end
