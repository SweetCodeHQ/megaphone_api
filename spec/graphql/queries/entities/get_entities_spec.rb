require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity' do
    let(:entity1) { create(:entity) }
    let(:entity2) { create(:entity) }

    let(:query_type_all) { "entities" }
    let(:query_string_all) { <<~GQL
      query entities {
        entities {
          id
          url
          name
        }
      }
    GQL
    }
    describe "return one entity" do
      describe "happy path" do
        before do
          entity1
          entity2
          query query_string_all
        end

        it 'should return no errors' do
          expect(gql_response.errors).to be_nil
        end

        it 'should return one entity' do
          expect(gql_response.data["entities"]).to be_an Array
          expect(gql_response.data["entities"].length).to be(2)
          expect(gql_response.data["entities"].first.keys).to eq(["id", "url", "name"])
        end
      end
    end

    describe "get entity with user count" do
      let(:user1)   {create(:user)}
      let(:user2)   {create(:user)}
      let(:user3)   {create(:user)}

      let(:entity1) {create(:entity)}
      let(:entity2) {create(:entity)}

      let(:user_entity1) {create(:user_entity, user: user1, entity: Entity.first)}
      let(:user_entity2) {create(:user_entity, user: user2, entity: Entity.first)}
      let(:user_entity3) {create(:user_entity, user: user3, entity: Entity.last)}

      let(:query_type_user_count) { "userCount" }
      let(:query_string_user_count) { <<~GQL
        query entities {
          entities {
            name
            userCount
          }
        }
      GQL
      }

      before do
        user1
        user2
        user3
        entity1
        entity2
        user_entity1
        user_entity2
        user_entity3
        query query_string_user_count
      end

      it "should have no errors" do
        expect(gql_response.errors).to be_nil
      end

      it "should pull user count with each entity" do
        expect(gql_response.data["entities"]).to be_an Array
        expect(gql_response.data["entities"].length).to be(2)

        expect(gql_response.data["entities"].first).to be_a Hash
        expect(gql_response.data["entities"].first.keys).to eq(["name", "userCount"])
        expect(gql_response.data["entities"].first["name"]).to eq(Entity.first.name)
        expect(gql_response.data["entities"].first["userCount"]).to eq(2)
        expect(gql_response.data["entities"].last["userCount"]).to eq(1)
      end
    end

    describe "sad path" do

    end
  end
end
