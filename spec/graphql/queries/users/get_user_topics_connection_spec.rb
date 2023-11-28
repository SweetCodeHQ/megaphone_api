require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe '.resolve' do
    let(:user) { create(:user) }
    let(:query_first_page) {
      <<~GQL
        query {
          userTopicsConnection {
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
        query {
          userTopicsConnection(after: "MTA") {
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
        query {
          userTopicsConnection(after: "MjA") {
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
        query($before: String!, $last: Int) {
          userTopicsConnection(before: $before, last: $last) {
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
      post '/graphql', params: { query: query_first_page }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }

      json = JSON.parse(response.body, symbolize_names: true)
      data = json[:data][:userTopicsConnection]

      expect(data.keys).to eq([:totalCount, :pageInfo, :edges])
      expect(data[:totalCount]).to eq(30)

      page_info = data[:pageInfo]
      topics = data[:edges]

      expect(page_info).to eq({:endCursor =>"MTA", :startCursor=>"MQ", :hasPreviousPage=>false, :hasNextPage=>true})
      expect(topics.size).to eq(10)
    end

    it 'returns second page' do
      post '/graphql', params: { query: query_second_page }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }

      json = JSON.parse(response.body)
      data = json['data']['userTopicsConnection']
      page_info = data['pageInfo']
      topics = data['edges']

      expect(page_info).to eq({"endCursor"=>"MjA", "startCursor"=>"MTE", "hasPreviousPage"=>true, "hasNextPage"=>true})
      expect(topics.size).to eq(10)
    end

    it 'returns the third page' do
      post '/graphql', params: { query: query_third_page }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }

      json = JSON.parse(response.body)
      data = json['data']['userTopicsConnection']

      page_info = data['pageInfo']
      topics = data['edges']

      expect(page_info).to eq({"endCursor"=>"MzA", "startCursor"=>"MjE", "hasPreviousPage"=>true, "hasNextPage"=>false})
      expect(topics.size).to eq(10)
    end

    it 'returns the second page through backwards pagination' do
      variables = { before: "MjE", last: 10 }

      post '/graphql', params: { query: query_backwards, variables: variables.to_json }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }

      json = JSON.parse(response.body)

      data = json['data']['userTopicsConnection']
      page_info = data['pageInfo']
      topics = data['edges']

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
        query {
          userTopicsConnection {
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
      post '/graphql', params: { query: query1 }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }

      json = JSON.parse(response.body)
      data = json['data']['userTopicsConnection']

      topics = data['edges']

      expect(topics.first["node"]["submitted"]).to be(true)
    end
  end
end
