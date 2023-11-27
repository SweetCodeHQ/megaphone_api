require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get user' do
    let(:user1) { create(:user, login_count: 1) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user, is_admin: true, login_count: 2)}

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
          user3
          post '/graphql', params: { query: query_string_one }, headers: { authorization: ENV['EAGLE_KEY'], user: user3.id }
        end


        it 'should return no errors' do
          expect(response.body['errors']).to be_nil
        end

        it 'should return waitlist' do
          json = JSON.parse(response.body)
          data = json['data']['waitlist']

          expect(data).to be_an Array
          expect(data).to eq([{
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
            post '/graphql', params: { query: query_string_one , variables: {email: "notAnEmail"} }, headers: { authorization: ENV['EAGLE_KEY'], user: user3.id }

            expect(response.body['data']['errors']).to be_nil
            expect(response.body['data']['users']). to be_nil
          end
        end
      end
    end
  end
end
