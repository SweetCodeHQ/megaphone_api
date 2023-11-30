require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get user' do
    let(:user) { create(:user) }
    let(:topic) { create(:topic) }
    let(:topic2) { create(:topic) }

    let(:query_type_one) { "user" }
    let(:query_string_one) { <<~GQL
      query User {
        user {
          id
          industry
          email
          isAdmin
          loginCount
          clickedGenerateCount
          topicCount
          createdAt
          onboarded
        }
      }
    GQL
    }
    describe "return one user" do
      describe "happy path" do
        before do
          user
          topic
          topic2
           post '/graphql', params: { query: query_string_one }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
        end


        it 'should return no errors' do
          json = JSON.parse(response.body)
          data = json['data']

          expect(data['errors']).to be_nil
        end

        it 'should return one user' do
          json = JSON.parse(response.body)
          data = json['data']['user']

          expect(data).to be_a Hash
          expect(data).to eq({
            "id" => user.id.to_s,
            "industry" => 0,
            "email" => user.email,
            "isAdmin" => user.is_admin,
            "loginCount" => user.login_count,
            "clickedGenerateCount" => user.clicked_generate_count,
            "topicCount" => 2,
            "createdAt" => Time.parse(user.created_at.to_s).iso8601,
            "onboarded" => false
          })
        end
      end

      describe "sad path" do
        context "email does not exist" do
          it 'should return an error' do
            user
            query query_string_one, variables: { email: "notAnEmail" }

            expect(gql_response.errors).to be_nil
            expect(gql_response.data["user"]). to be_nil
          end
        end
      end
    end
  end
end
