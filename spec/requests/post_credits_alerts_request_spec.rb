require 'rails_helper'

RSpec.describe "create emails with SendGrid", type: :request do
  describe 'topic email requests through SendGrid' do
    describe 'happy path' do
      it 'sends an email when there is an entity' do
        create(:user)
        create(:entity)
        create(:user_entity)

        params = { user_id: User.first.id }

        post '/credits_alert_emails', params: params

        expect(response.status).to eq(204)
      end

      it 'sends an email when there is no entity' do
        create(:user)

        params = { user_id: User.last.id }

        post '/credits_alert_emails', params: params

        expect(response.status).to eq(204)
      end
    end
  end
end
