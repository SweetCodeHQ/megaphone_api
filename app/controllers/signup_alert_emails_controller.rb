class SignupAlertEmailsController < ApplicationController
  require 'sendgrid-ruby'

  def create
    # need to clean this up and add require/permit topic_params
    #Should also pull redundant code to ApplicationController
    user = User.find(params["user_id"])

    email_body = "#{user.email} just registered."

    from = SendGrid::Email.new(email: 'robert@fixate.io')
    to = SendGrid::Email.new(email: ENV["ALERT_EMAIL_ADDRESS"])
    subject = 'New User Alert'
    content = SendGrid::Content.new(type: 'text/plain', value: email_body)

    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
