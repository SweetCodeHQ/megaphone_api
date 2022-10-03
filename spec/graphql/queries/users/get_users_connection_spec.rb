require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe '.resolve' do
    before do
      create_list(:user, 30)
    end

    it 'returns first page' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)

      page_info = json['data']['usersConnection']['pageInfo']
      users = json['data']['usersConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MTA", "startCursor"=>"MQ", "hasPreviousPage"=>false, "hasNextPage"=>true})
      expect(users.size).to eq(10)
    end

    it 'returns second page' do
      post '/graphql', params: { query: query2 }
      json = JSON.parse(response.body)

      page_info = json['data']['usersConnection']['pageInfo']
      users = json['data']['usersConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MjA", "startCursor"=>"MTE", "hasPreviousPage"=>true, "hasNextPage"=>true})
      expect(users.size).to eq(10)
    end

    it 'returns the third page' do
      post '/graphql', params: { query: query3 }
      json = JSON.parse(response.body)

      page_info = json['data']['usersConnection']['pageInfo']
      users = json['data']['usersConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MzA", "startCursor"=>"MjE", "hasPreviousPage"=>true, "hasNextPage"=>false})
      expect(users.size).to eq(10)
    end

    it 'returns the second page through backwards pagination' do
      post '/graphql', params: { query: query4 }
      json = JSON.parse(response.body)

      page_info = json['data']['usersConnection']['pageInfo']
      users = json['data']['usersConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MjA", "startCursor"=>"MTE", "hasPreviousPage"=>true, "hasNextPage"=>true})
      expect(users.size).to eq(10)
    end
  end

  def query
    <<~GQL
      query {
        usersConnection {
          pageInfo {
          endCursor
          startCursor
          hasPreviousPage
          hasNextPage
          }
          edges {
            cursor
            node {
              id
              email
              isBlocked
            }
          }
        }
      }
    GQL
  end

  def query2
    <<~GQL
      query {
        usersConnection(after: "MTA") {
          pageInfo {
          endCursor
          startCursor
          hasPreviousPage
          hasNextPage
          }
          edges {
            cursor
            node {
              email
            }
          }
        }
      }
    GQL
  end

  def query3
    <<~GQL
      query {
        usersConnection(after: "MjA") {
          pageInfo {
          endCursor
          startCursor
          hasPreviousPage
          hasNextPage
          }
          edges {
            cursor
            node {
              email
            }
          }
        }
      }
    GQL
  end

  def query4
    <<~GQL
      query {
        usersConnection(before: "MjE", last: 10) {
          pageInfo {
          endCursor
          startCursor
          hasPreviousPage
          hasNextPage
          }
          edges {
            cursor
            node {
              email
            }
          }
        }
      }
    GQL
  end
end
