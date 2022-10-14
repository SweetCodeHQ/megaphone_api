require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe '.resolve' do
    before do
      create_list(:keyword, 30)

      Keyword.first.update!(search_count: 5)
      Keyword.last.update!(search_count: 3)
    end

    it 'returns random keywords' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)
      keywords = json['data']['topFiveKeywords']

      expect(keywords).to be_an(Array)
      expect(keywords.size).to eq(5)
      expect(keywords.first).to be_a(Hash)
      expect(keywords.first["searchCount"]).to eq(5)
      expect(keywords[1]["searchCount"]).to eq(3)
    end
  end

  def query
    <<~GQL
      query TopFiveKeywords {
        topFiveKeywords {
          word
          searchCount
          id
          }
        }
    GQL
  end
end
