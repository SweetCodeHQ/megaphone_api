class SignupAlertEmailsController < ApplicationController
  require 'sendgrid-ruby'

  def create
    user = User.find(user_params["user_id"])

    email_body = "#{user.email} just registered."

    from = SendGrid::Email.new(email: 'robert@fixate.io')
    to = SendGrid::Email.new(email: ENV["ALERT_EMAIL_ADDRESS"])
    subject = 'New User Alert'
    content = SendGrid::Content.new(type: 'text/plain', value: email_body)

    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  private

  def user_params
    params.permit(:user_id)
  end
end
