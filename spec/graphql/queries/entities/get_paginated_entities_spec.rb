require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe '.resolve' do
    it 'returns all books with pagination' do
      create(:entity)
      create(:entity)
      create(:entity)

      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)

      page_info = json['data']['entitiesConnection']['pageInfo']

      expect(page_info).to eq({"endCursor"=>"Mg", "startCursor"=>"MQ", "hasPreviousPage"=>false, "hasNextPage"=>true})
    end
  end

  def query
    <<~GQL
      query {
        entitiesConnection(first: 2, after: "Mg") {
          pageInfo {
          endCursor
          startCursor
          hasPreviousPage
          hasNextPage
          }
          edges {
            cursor
            node {
              name
              url
            }
          }
        }
      }
    GQL
  end
end
