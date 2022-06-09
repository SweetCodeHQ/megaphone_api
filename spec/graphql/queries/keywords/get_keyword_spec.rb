require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get keyword' do
    let(:keyword) { create(:keyword) }

    let(:query_type_one) { "keyword" }
    let(:query_string_one) { <<~GQL
      query keyword($id: ID!) {
        keyword(id: $id) {
          id
          word
        }
      }
    GQL
    }

    describe "return one keyword" do
      describe "happy path" do
        before do
          keyword
          query query_string_one, variables: { id: "#{keyword.id}" }
        end

        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return one user' do
          expect(gql_response.data["keyword"]).to be_a Hash
          expect(gql_response.data["keyword"]).to eq({
            "id"    => keyword.id.to_s,
            "word"  => keyword.word
          })
        end
      end

      # describe "sad path" do
      #   context "keyword does not exist" do
      #     it 'should return an error' do
      #       keyword
      #       query query_string_one, variables: { id: 1 }
      #
      #       expect(gql_response.errors).to be_nil
      #       expect(gql_response.data["keyword"]). to be_nil
      #     end
      #   end
      # end
    end
  end
end
