require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get markets for an entity' do
    let(:market)        { create(:market) }
    let(:entity)        { create(:entity) }
    let(:entity_market) { create(:entity_market) }

    let(:query_type_all) { "entity markets" }
    let(:query_string_all) { <<~GQL
      query enitityByUrl($url: String!) {
        entity(url: $url) {
          url
          markets {
            id
            name
          }
        }
      }
    GQL
    }
    describe "return the markets for an entity" do
      before do
        market
        entity
        entity_market
        query query_string_all, variables: { url: "#{Entity.last.url}" }
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return an entity' do
        expect(gql_response.data["entity"]["markets"]).to be_an Array
        expect(gql_response.data["entity"]["markets"]).to eq([{
          "id" => market.id.to_s,
          "name" => market.name
        }])
      end
    end
  end
end
