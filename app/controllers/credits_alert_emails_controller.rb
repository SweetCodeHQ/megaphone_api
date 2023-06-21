class CreditsAlertEmailsController < ApplicationController
  require 'sendgrid-ruby'

  def create
    user = User.find(user_params[:user_id])

    credits_phrase = user.entities.first&.credits ? user.entities.first.credits : "not yet purchased"

    account_sentence = user.entities.first ? "The user belongs to the #{user.entities.first.url} account, which has #{credits_phrase} credits."
    : "The user is not currently associated with an account."

    email_body = "User #{user.email} has sent a request for additional credits. \n\n#{account_sentence}"

    from = SendGrid::Email.new(email: 'robert@fixate.io')
    to = SendGrid::Email.new(email: ENV["ALERT_EMAIL_ADDRESS"])
    subject = 'Credits Request'
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
