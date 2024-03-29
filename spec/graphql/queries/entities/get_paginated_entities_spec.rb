require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe '.resolve' do
    before do
      create(:user, is_admin: true)
      create_list(:entity, 30)
    end

    it 'returns first page' do
      post '/graphql', params: { query: query }, headers: { authorization: ENV['EAGLE_KEY'], user: User.first.id }
      json = JSON.parse(response.body)

      page_info = json['data']['entitiesConnection']['pageInfo']
      entities = json['data']['entitiesConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MTA", "startCursor"=>"MQ", "hasPreviousPage"=>false, "hasNextPage"=>true})
      expect(entities.size).to eq(10)
    end

    it 'returns second page' do
      post '/graphql', params: { query: query2 }, headers: { authorization: ENV['EAGLE_KEY'], user: User.first.id }
      json = JSON.parse(response.body)

      page_info = json['data']['entitiesConnection']['pageInfo']
      entities = json['data']['entitiesConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MjA", "startCursor"=>"MTE", "hasPreviousPage"=>true, "hasNextPage"=>true})
      expect(entities.size).to eq(10)
    end

    it 'returns the third page' do
      post '/graphql', params: { query: query3 }, headers: { authorization: ENV['EAGLE_KEY'], user: User.first.id }
      json = JSON.parse(response.body)

      page_info = json['data']['entitiesConnection']['pageInfo']
      entities = json['data']['entitiesConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MzA", "startCursor"=>"MjE", "hasPreviousPage"=>true, "hasNextPage"=>false})
      expect(entities.size).to eq(10)
    end

    it 'returns the second page through backwards pagination' do
      post '/graphql', params: { query: query4 }, headers: { authorization: ENV['EAGLE_KEY'], user: User.first.id }
      json = JSON.parse(response.body)

      page_info = json['data']['entitiesConnection']['pageInfo']
      entities = json['data']['entitiesConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MjA", "startCursor"=>"MTE", "hasPreviousPage"=>true, "hasNextPage"=>true})
      expect(entities.size).to eq(10)
    end
  end

  def query
    <<~GQL
      query {
        entitiesConnection {
          totalCount
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

  def query2
    <<~GQL
      query {
        entitiesConnection(after: "MTA") {
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

  def query3
    <<~GQL
      query {
        entitiesConnection(after: "MjA") {
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

  def query4
    <<~GQL
      query {
        entitiesConnection(before: "MjE", last: 10) {
          totalCount
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
