require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get markets for an entity' do
    let(:user)          { create(:user) }
    let(:market)        { create(:market) }
    let(:entity)        { create(:entity) }
    let(:entity_market) { create(:entity_market) }
    let(:user_entity)   { create(:user_entity) }

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
        user
        market
        entity
        user_entity
        entity_market
        post '/graphql', params: { query: query_string_all, variables: { url: "#{Entity.last.url}" } }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
      end

      it 'should return no errors' do
        json = JSON.parse(response.body)

        expect(json['data']['errors']).to be_nil
      end

      it 'should return an entity' do
        json = JSON.parse(response.body)
        data = json['data']['entity']['markets']

        expect(data).to be_an Array
        expect(data).to eq([{
          "id" => market.id.to_s,
          "name" => market.name
        }])
      end
    end
  end
end
