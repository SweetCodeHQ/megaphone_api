require 'rails_helper'

module Mutations
  module Banners
    RSpec.describe CreateBanner, type: :request do
      describe '.resolve' do
        before do
          create(:user, is_admin: true)
        end

        it 'creates a banner' do
          expect do
            post '/graphql', params: { query: g_query(text: "Texty text", link: "widget.com", purpose: 0) }, headers: { authorization: ENV['EAGLE_KEY'], user: User.first.id }
          end.to change { Banner.count }.by(1)
        end

        it 'returns a Banner' do
          post '/graphql', params: { query: g_query(text: "Text for a banner", link: "Wide.com", purpose: 0) }, headers: { authorization: ENV['EAGLE_KEY'], user: User.first.id }

          json = JSON.parse(response.body, symbolize_names: true)

          data = json[:data][:createBanner]
          expect(data).to include(
            id: "#{Banner.last.id}",
            text: "Text for a banner",
            link: "Wide.com",
            purpose: 0
          )
        end

        def g_query(text:, link:, purpose:)
          <<~GQL
            mutation createBanner {
              createBanner( input: {
                text: "#{text}"
                link: "#{link}"
                purpose: #{purpose}
              } ){
                id
                text
                link
                purpose
              }
            }
          GQL
        end
      end

      describe 'sad path' do
        it 'returns errors if text is not supplied' do

          post '/graphql', params: { query: g_query(link: "A name") }, headers: { authorization: ENV['MUTATION_KEY'] }
          json = JSON.parse(response.body, symbolize_names: true)

          expect(json).to have_key(:errors)
        end

        def g_query(link:)
          <<~GQL
            mutation {
              createEntity( input: {
                link: #{link}
              } ){
                id
                link
                text
              }
            }
          GQL
        end
      end
    end
  end
end
