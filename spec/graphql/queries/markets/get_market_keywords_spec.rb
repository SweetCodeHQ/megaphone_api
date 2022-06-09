require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get markets for an entity' do
    let(:market)         { create(:market) }
    let(:keyword)        { create(:keyword) }
    let(:market_keyword) { create(:market_keywords) }

    let(:query_type_all) { "market keywords" }
    let(:query_string_all) { <<~GQL
      query marketById($id: ID!) {
        market(id: $id) {
          id
          name
          keywords {
            id
            word
          }
        }
      }
    GQL
    }
    describe "return the markets for an entity" do
      before do
        market
        keyword
        market_keyword
        query query_string_all, variables: { id: "#{Market.last.id}" }
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return an entity' do
        expect(gql_response.data["market"]["keywords"]).to be_an Array
        expect(gql_response.data["market"]["keywords"]).to eq([{
          "id" => keyword.id.to_s,
          "word" => keyword.word
        }])
      end
    end
  end
end
