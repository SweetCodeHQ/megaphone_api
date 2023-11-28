require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get topics for a user' do
    let(:user)         { create(:user) }
    let(:topic)        { create(:topic) }
    let(:topic2)       { create(:topic) }

    let(:query_type_all) { "user topics" }
    let(:query_string_all) { <<~GQL
      query userByEmail($email: String!) {
        user(email: $email) {
          id
          email
          topicCount
          topics {
            id
            text
          }
        }
      }
    GQL
    }
    describe "return the topics for a user" do
      before do
        user
        topic
        topic2
        post '/graphql', params: { query: query_string_all, variables: { email: "#{User.last.email}" } }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
      end

      it 'should return no errors' do
        json = JSON.parse(response.body)
        data = json['data']

        expect(data['errors']).to be_nil
      end

      it 'should return topics for a user' do
        json = JSON.parse(response.body)
        data = json['data']['user']

        expect(data["topics"]).to be_an Array
        expect(data["topicCount"]).to eq(2)
        expect(data["topics"]).to eq([{
          "id" => topic2.id.to_s,
          "text" => topic2.text
        },
        {"id" => topic.id.to_s,
        "text" => topic.text}])
      end
    end
  end
end
