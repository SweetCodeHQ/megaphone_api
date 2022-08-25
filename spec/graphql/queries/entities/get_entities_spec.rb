require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity' do
    let(:entity1) { create(:entity) }
    let(:entity2) { create(:entity) }

    let(:query_type_all) { "entities" }
    let(:query_string_all) { <<~GQL
      query entities {
        entities {
          id
          url
          name
        }
      }
    GQL
    }
    describe "return one entity" do
      describe "happy path" do
        before do
          entity1
          entity2
          query query_string_all
        end

        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return one user' do
          expect(gql_response.data["entities"]).to be_an Array
          expect(gql_response.data["entities"].length).to be(2)
          expect(gql_response.data["entities"].first.keys).to eq(["id", "url", "name"])
        end
      end

      describe "sad path" do

      end
    end
  end
end
