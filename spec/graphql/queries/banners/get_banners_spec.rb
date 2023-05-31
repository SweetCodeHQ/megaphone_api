require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get banner' do
    let(:banner) { create(:banner) }

    let(:query_type_all) { "banners" }
    let(:query_string_all) { <<~GQL
      query banners {
        banners {
          id
          text
          link
        }
      }
    GQL
    }

    describe "return one banner" do
      describe "happy path" do
        before do
          banner

          query query_string_all
        end

        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return one entity' do
          expect(gql_response.data["banners"]).to be_an Array
          expect(gql_response.data["banners"].length).to be(1)
          expect(gql_response.data["banners"].first.keys).to eq(["id", "text",
          "link"])
        end
      end
    end

    describe "sad path" do

    end
  end
end
