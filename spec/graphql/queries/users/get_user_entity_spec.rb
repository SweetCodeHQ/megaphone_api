require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity for a user' do
    let(:user)          { create(:user) }
    let(:entity)        { create(:entity) }
    let(:user_entity)   { create(:user_entity) }

    let(:query_type_all) { "user_entities" }
    let(:query_string_all) { <<~GQL
      query User {
        user {
          email
          entities {
            id
            name
            url
          }
        }
      }
    GQL
    }
    describe "return the entity for a user" do
      before do
        user
        entity
        user_entity
        post '/graphql', params: { query: query_string_all }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
      end

      it 'should return no errors' do
        json = JSON.parse(response.body)
        data = json['data']

        expect(data['errors']).to be_nil
      end

      it 'should return an entity' do
        json = JSON.parse(response.body)
        data = json['data']['user']['entities']

        expect(data).to be_an Array
        expect(data).to eq([{
          "id" => entity.id.to_s,
          "url" => entity.url,
          "name" => entity.name
        }])
      end
    end
  end
end
