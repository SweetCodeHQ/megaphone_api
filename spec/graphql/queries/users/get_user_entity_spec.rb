require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity for a user' do
    let(:user)          { create(:user) }
    let(:entity)        { create(:entity) }
    let(:user_entity)   { create(:user_entity) }

    let(:query_type_all) { "user_entity" }
    let(:query_string_all) { <<~GQL
      query user($email: String!) {
        user(email: $email) {
          email
          entity {
            id
            name
            url
          }
        }
      }
    GQL
    }
    describe "return the employees for a flight" do
      before do
        user
        entity
        user_entity
        query query_string_all, variables: { email: "#{User.last.email}" }
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return an entity' do
        # expect(gql_response.data["user"]["entity"]).to be_an Array
        expect(gql_response.data["user"]["entity"]).to eq({
          "id" => entity.id.to_s,
          "url" => entity.url,
          "name" => entity.name
        })
      end
    end
  end
end
