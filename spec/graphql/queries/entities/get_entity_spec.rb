require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity' do
    let(:entity) { create(:entity) }

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
          entity
          query query_string_one, variables: { url: "#{entity.url}" }
        end

        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return one entity' do
          expect(gql_response.data["entity"]).to be_a Hash
          expect(gql_response.data["entity"]).to eq({
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
            entity
            query query_string_one, variables: { url: "notAnEmail" }

            expect(gql_response.errors).to be_nil
            expect(gql_response.data["entity"]). to be_nil
          end
        end
      end
    end
  end
end
