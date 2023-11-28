require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get user' do
    let(:user)      { create(:user) }
    let(:topic)     { create(:topic) }
    let(:abstract)  { create(:abstract) }

    let(:query_type_one) { "topic" }
    let(:query_string_one) { <<~GQL
      query topic($id: ID!) {
        topic(id: $id) {
          id
          text
          contentType
          abstract {
            id
            text
          }
        }
      }
    GQL
    }
    describe "return one topic" do
      describe "happy path" do
        before do
          user
          topic
          abstract

          post '/graphql', params: { query: query_string_one, variables: { id: "#{topic.id}" } }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
        end

        it 'should return no errors' do
          json = JSON.parse(response.body, symbolize_names: true)
          errors = json[:data][:errors]

          expect(errors).to be_nil
        end

        it 'should return one user' do
          json = JSON.parse(response.body)
          data = json["data"]["topic"]

          expect(data).to be_a Hash
          expect(data).to eq({
            "id" => topic.id.to_s,
            "text" => topic.text,
            "contentType" => 0,
            "abstract" => {
              "id" => abstract.id.to_s,
              "text" => abstract.text
            }
          })
        end
      end

      # describe "sad path" do
      #   context "id does not exist" do
      #     it 'should return an error' do
      #       user
      #       query query_string_one, variables: { id: "notAnId" }
      #
      #       expect(gql_response.errors).to not_be(nil)
      #       expect(gql_response.data["topic"]). to be_nil
      #     end
      #   end
      # end
    end
  end
end
