require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get banner' do
    let(:user)    { create(:user) }
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
          updatedAt
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

          post '/graphql', params: { query: query_string_all }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
        end

        it 'should return no errors' do
          json = JSON.parse(response.body, symbolize_names: true)
          errors = json[:data][:errors]

          expect(errors).to be_nil
        end

        it 'should return banners' do
          json = JSON.parse(response.body)
          data = json["data"]["banners"]

          expect(data).to be_an Array
          expect(data.length).to be(4)
          expect(data.first.keys).to eq(["id", "text",
          "link", "updatedAt"])
        end

        it 'orders banners by id' do
          json = JSON.parse(response.body)
          data = json["data"]["banners"]

          banner3.update!(text: "New Text")

          ids = data.map { |banner| banner["id"]}

          expect(ids).to eq(ids.sort)
        end
      end


    end

    describe "sad path" do

    end
  end
end
