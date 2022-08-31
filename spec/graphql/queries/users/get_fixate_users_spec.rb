require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity for a user' do
    let(:user1)         { create(:user) }
    let(:user2)         { create(:user) }
    let(:entity)        { create(:entity, name: "Fixate") }
    let(:user_entity)   { create(:user_entity, user: user1) }

    let(:query_type_all) { "fixate_users" }
    let(:query_string_all) { <<~GQL
      { fixateUsers {
          email
          isAdmin
          entities {
            name
          }
        }
      }
    GQL
    }
    describe "return all admin users" do
      before do
        user1
        user2
        entity
        user_entity
        query query_string_all
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return a list of admin users' do
        expect(gql_response.data["fixateUsers"]).to be_an Array
        expect(gql_response.data["fixateUsers"].size).to eq(1)
        expect(gql_response.data["fixateUsers"].first["entities"].first["name"]).to eq("Fixate")
      end
    end
  end
end
