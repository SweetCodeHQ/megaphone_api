require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get banner' do
    let(:banner)  { create(:banner, purpose: 0) }
    let(:banner2) { create(:banner, purpose: 1) }
    let(:banner3) { create(:banner, purpose: 2) }
    let(:banner4) { create(:banner, purpose: 3) }

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

    describe "return banners" do
      describe "happy path" do
        before do
          banner
          banner2
          banner3
          banner4
        end

        it 'should return no errors' do
          query query_string_all
          expect(gql_response.errors).to be_nil
        end

        it 'should return banners' do
          query query_string_all
          expect(gql_response.data["banners"]).to be_an Array
          expect(gql_response.data["banners"].length).to be(4)
          expect(gql_response.data["banners"].first.keys).to eq(["id", "text",
          "link"])
        end

        it 'orders banners by id' do
          query query_string_all
          banner3.update!(text: "New Text")

          query query_string_all
          ids = gql_response.data["banners"].map { |banner| banner["id"]}

          expect(ids).to eq(ids.sort)
        end
      end


    end

    describe "sad path" do

    end
  end
end
