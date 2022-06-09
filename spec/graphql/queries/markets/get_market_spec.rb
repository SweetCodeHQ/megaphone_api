require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get market' do
    let(:market) { create(:market) }

    let(:query_type_one) { "market" }
    let(:query_string_one) { <<~GQL
      query market($id: ID!) {
        market(id: $id) {
          id
          name
        }
      }
    GQL
    }

    describe "return one market" do
      describe "happy path" do
        before do
          market
          query query_string_one, variables: { id: "#{market.id}" }
        end

        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return one user' do
          expect(gql_response.data["market"]).to be_a Hash
          expect(gql_response.data["market"]).to eq({
            "id"    => market.id.to_s,
            "name"  => market.name
          })
        end
      end

      # describe "sad path" do
      #   context "market does not exist" do
      #     it 'should return an error' do
      #       market
      #       query query_string_one, variables: { id: 1 }
      #
      #       expect(gql_response.errors).to be_nil
      #       expect(gql_response.data["market"]). to be_nil
      #     end
      #   end
      # end
    end
  end
end
