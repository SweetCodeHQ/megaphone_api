require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get user' do
    let(:user)      { create(:user) }
    let(:topic)     { create(:topic) }
    let(:keyword1)  { create(:keyword) }
    let(:topic_keyword) { create(:topic_keyword) }
    let(:keyword2)  { create(:keyword) }

    let(:query_type_one) { "topic" }
    let(:query_string_one) { <<~GQL
      query topic($id: ID!) {
        topic(id: $id) {
          id
          text
          keywords {
            id
            word
          }
        }
      }
    GQL
    }

    describe "return a topic's keywords" do
      describe "happy path" do
        before do
          user
          topic
          keyword1
          topic_keyword
          post '/graphql', params: { query: query_string_one, variables: { id: "#{topic.id}" } }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
        end

        it 'should return no errors' do
          json = JSON.parse(response.body, symbolize_names: true)
          errors = json[:data][:errors]

          expect(errors).to be_nil
        end

        it 'should return keywords for a topic' do
          json = JSON.parse(response.body)
          data = json["data"]["topic"]

          expect(data).to be_a Hash
          expect(data).to eq({
            "id" => topic.id.to_s,
            "text" => topic.text,
            "keywords" => [
              {
                "id" => keyword1.id.to_s,
                "word" => keyword1.word
              }
            ]
          })
        end
      end
    end
  end
end
