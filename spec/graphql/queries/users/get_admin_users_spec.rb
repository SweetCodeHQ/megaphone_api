require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity for a user' do
    let(:user)          { create(:user) }
    let(:user2)         { create(:user, is_admin: true) }
    let(:user3)         { create(:user, is_admin: true) }

    let(:query_type_all) { "admin_users" }
    let(:query_string_all) { <<~GQL
      { adminUsers {
          id
          email
          isAdmin
        }
      }
    GQL
    }
    describe "return all admin users" do
      before do
        user
        user2
        user3
        query query_string_all
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return a list of admin users' do
        expect(gql_response.data["adminUsers"]).to be_an Array
        expect(gql_response.data["adminUsers"].size).to eq(2)
        expect(gql_response.data["adminUsers"].first["isAdmin"]).to be(true)
        expect(gql_response.data["adminUsers"].last["isAdmin"]).to be(true)
      end
    end
  end
end
