require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe '.resolve' do
    let(:user) { create(:user) }
    let(:query_first_page) {
      <<~GQL
        query($userId: ID!) {
          userTopicsConnection(userId: $userId) {
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
                text
              }
            }
          }
        }
      GQL
    }

    let(:query_second_page) {
      <<~GQL
        query($userId: ID!) {
          userTopicsConnection(userId: $userId, after: "MTA") {
            pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
            }
            edges {
              cursor
              node {
                text
              }
            }
          }
        }
      GQL
    }

    let(:query_third_page) {
      <<~GQL
        query($userId: ID!) {
          userTopicsConnection(userId: $userId, after: "MjA") {
            pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
            }
            edges {
              cursor
              node {
                text
              }
            }
          }
        }
      GQL
    }

    let(:query_backwards) {
      <<~GQL
        query($userId: ID!, $before: String!, $last: Int) {
          userTopicsConnection(userId: $userId, before: $before, last: $last) {
            pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
            }
            edges {
              cursor
              node {
                text
              }
            }
          }
        }
      GQL
    }

    before do
      user
      create_list(:topic, 30)
    end

    it 'returns first page' do
      query query_first_page, variables: {user_id: User.first.id}

      json = gql_response.data

      page_info = json['userTopicsConnection']['pageInfo']
      topics = json['userTopicsConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MTA", "startCursor"=>"MQ", "hasPreviousPage"=>false, "hasNextPage"=>true})
      expect(topics.size).to eq(10)
    end

    it 'returns second page' do
      query query_second_page, variables: {user_id: User.first.id}

      json = gql_response.data

      page_info = json['userTopicsConnection']['pageInfo']
      topics = json['userTopicsConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MjA", "startCursor"=>"MTE", "hasPreviousPage"=>true, "hasNextPage"=>true})
      expect(topics.size).to eq(10)
    end

    it 'returns the third page' do
      query query_third_page, variables: {user_id: User.first.id}

      json = gql_response.data

      page_info = json['userTopicsConnection']['pageInfo']
      topics = json['userTopicsConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MzA", "startCursor"=>"MjE", "hasPreviousPage"=>true, "hasNextPage"=>false})
      expect(topics.size).to eq(10)
    end

    it 'returns the second page through backwards pagination' do
      query query_backwards, variables: {user_id: User.first.id, before: "MjE", last: 10}

      json = gql_response.data

      page_info = json['userTopicsConnection']['pageInfo']
      topics = json['userTopicsConnection']['edges']

      expect(page_info).to eq({"endCursor"=>"MjA", "startCursor"=>"MTE", "hasPreviousPage"=>true, "hasNextPage"=>true})
      expect(topics.size).to eq(10)
    end
  end

  describe "return topics in order of   submitted" do
    let(:user)     { create(:user) }
    let(:topic)    { create(:topic) }
    let(:topic2)   { create(:topic, submitted: true) }

    let(:query1) {
      <<~GQL
        query($userId: ID!) {
          userTopicsConnection(userId: $userId) {
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
                text
                submitted
              }
            }
          }
        }
      GQL
    }

    before do
      user
      topic
      topic2
    end

    it 'returns topics in order of submitted status' do
      query query1, variables: {user_id: User.first.id}

      json = gql_response.data

      topics = json['userTopicsConnection']['edges']

      expect(topics.first["node"]["submitted"]).to be(true)
    end
  end
end
