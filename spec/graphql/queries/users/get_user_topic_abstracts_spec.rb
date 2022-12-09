require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get abstracts for a user' do
    let(:user)         { create(:user) }
    let(:topic)        { create(:topic) }
    let(:abstract)     { create(:abstract) }

    let(:query_type_all) { "user topic abstracts" }
    let(:query_string_all) { <<~GQL
      query userByEmail($email: String!) {
        user(email: $email) {
          id
          email
          topicCount
          topics {
            id
            text
            abstract {
              id
              text
            }
          }
        }
      }
    GQL
    }
    describe "return the topic abstracts for a user" do
      before do
        user
        topic
        abstract
        query query_string_all, variables: { email: "#{User.last.email}" }
      end

      it 'should return no errors' do
        expect(gql_response.errors).to be_nil
      end

      it 'should return abstracts for a user via topics' do
        expect(gql_response.data["user"]["topics"].first["abstract"]).to be_a Hash
        expect(gql_response.data["user"]["topics"].first["abstract"]).to eq({
          "id" => abstract.id.to_s,
          "text" => abstract.text
        })
      end
    end
  end
end
