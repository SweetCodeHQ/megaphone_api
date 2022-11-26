require 'rails_helper'

RSpec.describe "create emails with SendGrid", type: :request do
  describe 'topic email requests through SendGrid' do
    describe 'happy path' do
      it 'sends an email' do
        create(:user)
        create(:topic)

        params = { topic_id: Topic.last.id }

        post '/topic_alert_emails', params: params

        expect(response.status).to eq(204)
      end
    end
  end
end
