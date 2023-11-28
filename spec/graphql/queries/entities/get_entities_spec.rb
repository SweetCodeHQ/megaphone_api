require 'rails_helper'
include GraphQL::TestHelpers

RSpec.describe Types::QueryType, type: :request do
  describe 'get entity' do
    let(:user)    { create(:user, is_admin: true)   }
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
    describe "return all entitites" do
      describe "happy path" do
        before do
          user
          entity1
          entity2

          post '/graphql', params: { query: query_string_all }, headers: { authorization: ENV['EAGLE_KEY'], user: user.id }
        end

        it 'should return no errors' do
          json = JSON.parse(response.body, symbolize_names: true)
          errors = json[:data][:errors]

          expect(errors).to be_nil
        end

        it 'should return all entities' do
          json = JSON.parse(response.body)
          data = json["data"]["entities"]

          expect(data).to be_an Array
          expect(data.length).to be(2)
          expect(data.first.keys).to eq(["id", "url", "name"])
        end
      end
    end

    describe "get entity with user count" do
      let(:user1)   {create(:user)}
      let(:user2)   {create(:user)}
      let(:user3)   {create(:user)}
      let(:user4)   {create(:user, is_admin: true)}


      let(:topic)   {create(:topic, user: user1)}
      let(:topic2)   {create(:topic, user: user1)}
      let(:topic3)   {create(:topic, user: user2)}
      let(:entity1) {create(:entity)}
      let(:entity2) {create(:entity)}

      let(:user_entity1) {create(:user_entity, user: user1, entity: Entity.first)}
      let(:user_entity2) {create(:user_entity, user: user2, entity: Entity.first)}
      let(:user_entity3) {create(:user_entity, user: user3, entity: Entity.last)}

      let(:query_type_count) { "userCount" }
      let(:query_string_count) { <<~GQL
        query entities {
          entities {
            name
            userCount
            topicCount
          }
        }
      GQL
      }

      before do
        user1
        user2
        user3
        user4
        entity1
        entity2
        user_entity1
        user_entity2
        user_entity3
        topic
        topic2
        topic3
        
        post '/graphql', params: { query: query_string_count }, headers: { authorization: ENV['EAGLE_KEY'], user: user4.id }
      end

      it "should have no errors" do
        json = JSON.parse(response.body, symbolize_names: true)
          errors = json[:data][:errors]

          expect(errors).to be_nil
      end

      it "should pull user count and topic count with each entity" do
          json = JSON.parse(response.body)
          data = json["data"]["entities"]

        expect(data).to be_an Array
        expect(data.length).to be(2)

        expect(data.first).to be_a Hash
        expect(data.first.keys).to eq(["name", "userCount", "topicCount"])
        expect(data.first["name"]).to eq(Entity.first.name)
        expect(data.first["userCount"]).to eq(2)
        expect(data.last["userCount"]).to eq(1)

        expect(data.first["topicCount"]).to eq(3)
      end
    end

    describe "sad path" do

    end
  end
end
