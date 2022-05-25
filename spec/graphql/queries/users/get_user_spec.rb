require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get employees' do
    let(:user) { create(:user) }

    let(:query_type_one) { "user" }
    let(:query_string_one) { <<~GQL
      query user($email: String!) {
        user(email: $email) {
          id
          email
          isAdmin
        }
      }
    GQL
    }
    describe "return one user" do
      before do
        user
        query query_string_one, variables: { email: "#{user.email}" }
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return one user' do
        expect(gql_response.data["user"]).to be_a Hash
        expect(gql_response.data["user"]).to eq({
          "id" => user.id.to_s,
          "email" => user.email,
          "isAdmin" => user.is_admin
        })
      end
    end
  end
end
