require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe '.resolve' do
    before do
      create_list(:keyword, 30)
    end

    it 'returns random keywords' do
      post '/graphql', params: { query: query }, headers: { authorization: ENV['QUERY_KEY'] }
      json = JSON.parse(response.body)
      keywords = json['data']['randomKeywords']

      expect(keywords).to be_an(Array)
      expect(keywords.size).to eq(10)
      expect(keywords.first).to be_a(Hash)
    end
  end

  def query
    <<~GQL
      query randomKeywords {
        randomKeywords {
          word
          userCount
          id
          }
        }
    GQL
  end
end
