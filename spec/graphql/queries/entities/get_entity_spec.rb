require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity' do
    let(:user)          { create(:user) }
    let(:entity) { create(:entity) }
    let(:user_entity)   { create(:user_entity) }

    let(:query_type_one) { "entity" }
    let(:query_string_one) { <<~GQL
      query entity($url: String!) {
        entity(url: $url) {
          id
          url
          name
          credits
          requestInProgress
        }
      }
    GQL
    }

    describe "return one entity" do
      describe "happy path" do
        before do
          user
          entity
          user_entity
          post '/graphql', params: { query: query_string_one, variables: { url: "#{entity.url}" } }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }
        end

        it 'should return no errors' do
          json = JSON.parse(response.body, symbolize_names: true)
          errors = json[:data][:errors]

          expect(errors).to be_nil
        end

        it 'should return one entity' do
          json = JSON.parse(response.body)
          data = json["data"]["entity"]

          expect(data).to be_a Hash
          expect(data).to eq({
            "id"    => entity.id.to_s,
            "name"  => entity.name,
            "url"   => entity.url,
            "credits" => entity.credits,
            "requestInProgress" => false
          })
        end
      end

      describe "sad path" do
        context "entity does not exist" do
          it 'should return an error' do
            user
            entity
            user_entity
            post '/graphql', params: { query: query_string_one, variables: { url: "notAUrl" } }, headers: { authorization: ENV['QUERY_KEY'], user: user.id }

            json = JSON.parse(response.body)
            data = json["data"]

            expect(data["entity"]).to be_nil
          end
        end
      end
    end
  end
end
