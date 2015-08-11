class SlackNotification
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  def initialize(options={})
    @notifier = Slack::Notifier.new(webhook_url, {
      username: "Imperilment!",
      icon_emoji: ":imperilment:",
      channel: '#stembolt'
    }.merge(options))
  end

  def deliver
    return unless webhook_url
    @notifier.ping message, attachments: attachments
  end

  private

  def message
    ''
  end

  def attachments
    absolute_url = url_for([:root, { only_path: false }])
    [{
      title: "A message from Imperilment.",
      title_link: absolute_url,
      text: "A message for Slack.",
      color: "#337AB7",
      fallback: "A message for Slack from Imperilment. #{absolute_url}",
    }]
  end

  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
