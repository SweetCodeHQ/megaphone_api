require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get abstracts for a user' do
    let(:user)         { create(:user) }
    let(:topic)        { create(:topic) }
    let(:abstract)     { create(:abstract) }

    let(:query_type_all) { "user topic abstracts" }
    let(:query_string_all) { <<~GQL
      query userByEmail($email: String!) {
        user(email: $email) {
          id
          email
          topicCount
          topics {
            id
            text
            abstract {
              id
              text
            }
          }
        }
      }
    GQL
    }
    describe "return the topic abstracts for a user" do
      before do
        user
        topic
        abstract
        post '/graphql', params: { query: query_string_all, variables: { email: user.email } }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
      end

      it 'should return no errors' do
        json = JSON.parse(response.body)
        data = json['data']

        expect(data['errors']).to be_nil
      end

      it 'should return abstracts for a user via topics' do
        json = JSON.parse(response.body)
        data = json['data']['user']['topics']

        expect(data.first["abstract"]).to be_a Hash
        expect(data.first["abstract"]).to eq({
          "id" => abstract.id.to_s,
          "text" => abstract.text
        })
      end
    end
  end
end
