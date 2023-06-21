class TopicAlertEmailsController < ApplicationController
  require 'sendgrid-ruby'

  def create
    topic = Topic.find(topic_params["topic_id"])
    user = topic.user

    email_body = "#{user.email} has sent a request for the following topic: #{topic.text}. The abstract is as follows: #{topic.abstract&.text ? topic.abstract.text : "none generated"}."

    from = SendGrid::Email.new(email: 'robert@fixate.io')
    to = SendGrid::Email.new(email: ENV["ALERT_EMAIL_ADDRESS"])
    subject = 'New Topic Request'
    content = SendGrid::Content.new(type: 'text/plain', value: email_body)

    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  private

  def topic_params
    params.permit(:topic_id)
  end
end
