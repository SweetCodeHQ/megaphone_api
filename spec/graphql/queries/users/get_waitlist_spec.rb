require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get user' do
    let(:user1) { create(:user, login_count: 1) }
    let(:user2) { create(:user) }

    let(:query_type_one) { "waitlist" }
    let(:query_string_one) { <<~GQL
      query Waitlist {
        waitlist {
          id
          email
          loginCount
        }
      }
    GQL
    }

    describe "return waitlist" do
      describe "happy path" do
        before do
          user1
          user2
          query query_string_one
        end


        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return waitlist' do
          expect(gql_response.data["waitlist"]).to be_an Array
          expect(gql_response.data["waitlist"]).to eq([{
            "id" => user2.id.to_s,
            "email" => user2.email,
            "loginCount" => 0
          }])
        end
      end

      describe "sad path" do
        context "email does not exist" do
          it 'should return an error' do
            user1
            query query_string_one, variables: { email: "notAnEmail" }

            expect(gql_response.errors).to be_nil
            expect(gql_response.data["user"]). to be_nil
          end
        end
      end
    end
  end
end
