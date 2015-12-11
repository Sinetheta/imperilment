class SlackNotification
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  def initialize(options={})
    return unless webhook_url
    @notifier = Slack::Notifier.new(webhook_url, {
      username: "Imperilment!",
      icon_emoji: ":imperilment:",
      channel: '#stembolt'
    }.merge(options))
  end

  def deliver
    @notifier.ping(message, attachments: attachments) if @notifier
  end

  private

  def message
    ''
  end

  def attachments
    [{
      title: "A message from Imperilment.",
      title_link: root_url,
      text: "A message for Slack.",
      color: "#337AB7",
      fallback: "A message for Slack from Imperilment. #{root_url}",
    }]
  end

  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
