require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get keywords for a user' do
    let(:user)         { create(:user) }
    let(:user_keyword) { create(:user_keyword) }
    let(:keyword)      { create(:keyword) }

    let(:query_type_all) { "user topics" }
    let(:query_string_all) { <<~GQL
      query userByEmail($email: String!) {
        user(email: $email) {
          id
          email
          keywords {
            id
            word
          }
        }
      }
    GQL
    }

    describe "return the keywords for a user" do
      before do
        user
        keyword
        user_keyword
        query query_string_all, variables: { email: "#{User.last.email}" }
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return topics for a user' do
        expect(gql_response.data["user"]["keywords"]).to be_an Array
        expect(gql_response.data["user"]["keywords"]).to eq([{
          "id" => keyword.id.to_s,
          "word" => keyword.word
        }])
      end
    end
  end
end
