require 'rails_helper'

RSpec.describe "create user alert emails with SendGrid", type: :request do
  describe 'new user email requests through SendGrid' do
    describe 'happy path' do
      it 'sends an email' do
        create(:user)

        params = { user_id: User.last.id }

        post '/signup_alert_emails', params: params

        expect(response.status).to eq(204)
      end
    end
  end
end
