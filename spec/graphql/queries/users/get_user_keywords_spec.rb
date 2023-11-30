require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get keywords for a user' do
    let(:user)         { create(:user) }
    let(:user_keyword) { create(:user_keyword) }
    let(:keyword)      { create(:keyword) }

    let(:query_type_all) { "user topics" }
    let(:query_string_all) { <<~GQL
      query User {
        user {
          id
          email
          keywords {
            id
            word
          }
        }
      }
    GQL
    }

    describe "return the keywords for a user" do
      before do
        user
        keyword
        user_keyword
        post '/graphql', params: { query: query_string_all }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
      end

      it 'should return no errors' do
        json = JSON.parse(response.body)
        data = json['data']

        expect(data['errors']).to be_nil
      end

      it 'should return keywords for a user' do
        json = JSON.parse(response.body)
        data = json['data']['user']['keywords']

        expect(data).to be_an Array
        expect(data).to eq([{
          "id" => keyword.id.to_s,
          "word" => keyword.word
        }])
      end
    end
  end
end
