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
          query query_string_one, variables: { id: "#{topic.id}" }
        end

        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return keywords for a topic' do
          expect(gql_response.data["topic"]).to be_a Hash
          expect(gql_response.data["topic"]).to eq({
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
