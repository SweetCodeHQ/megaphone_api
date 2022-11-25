require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get user' do
    let(:user) { create(:user) }
    let(:topic) { create(:topic) }
    let(:topic2) { create(:topic) }

    let(:query_type_one) { "user" }
    let(:query_string_one) { <<~GQL
      query user($email: String!) {
        user(email: $email) {
          id
          email
          isAdmin
          loginCount
          clickedGenerateCount
          topicCount
        }
      }
    GQL
    }
    describe "return one user" do
      describe "happy path" do
        before do
          user
          query query_string_one, variables: { email: "#{user.email}" }
        end


        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return one user' do
          expect(gql_response.data["user"]).to be_a Hash
          expect(gql_response.data["user"]).to eq({
            "id" => user.id.to_s,
            "email" => user.email,
            "isAdmin" => user.is_admin,
            "loginCount" => user.login_count,
            "clickedGenerateCount" => user.clicked_generate_count,
            "topicCount" => user.topics.size
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
