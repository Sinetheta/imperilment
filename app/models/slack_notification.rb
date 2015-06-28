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
    @notifier.ping message
  end

  private

  def message
    ''
  end

  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
