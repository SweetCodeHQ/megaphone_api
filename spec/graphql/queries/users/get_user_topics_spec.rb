require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get topics for a user' do
    let(:user)         { create(:user) }
    let(:topic)        { create(:topic) }

    let(:query_type_all) { "user topics" }
    let(:query_string_all) { <<~GQL
      query userByEmail($email: String!) {
        user(email: $email) {
          id
          email
          topics {
            id
            text
          }
        }
      }
    GQL
    }
    describe "return the topics for a user" do
      before do
        user
        topic
        query query_string_all, variables: { email: "#{User.last.email}" }
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return topics for a user' do
        expect(gql_response.data["user"]["topics"]).to be_an Array
        expect(gql_response.data["user"]["topics"]).to eq([{
          "id" => topic.id.to_s,
          "text" => topic.text
        }])
      end
    end
  end
end
