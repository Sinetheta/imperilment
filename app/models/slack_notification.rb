class SlackNotification
  def initialize(options={})
    @notifier = Slack::Notifier.new(webhook_url, {
      username: "Imperilment!",
      icon_emoji: ":imperilment:",
      channel: '#random'
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
    [{
      title: "A message from Imperilment.",
      text: "A message for Slack.",
      color: "#337AB7",
      fallback: "A message for Slack from Imperilment.",
    }]
  end

  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
