require 'rails_helper'

RSpec.describe "create emails with SendGrid", type: :request do
  describe 'email requests through SendGrid' do
    describe 'happy path' do
      it 'sends an email' do
        create(:user)
        create(:topic)

        params = { topic_id: Topic.last.id }

        post '/email', params: params

        expect(response.status).to eq(204)
      end
    end
  end
end
