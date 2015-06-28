require 'spec_helper'

class NoOpHTTPClient
  def self.post uri, params={}
    params # return params so that we can inspect the payload intended for Slack
  end
end

RSpec.describe SlackNotification, type: :model do
  let(:notification) { SlackNotification.new(
        username: "Tester",
        icon_emoji: ":testing:",
        channel: '#test',
        http_client: NoOpHTTPClient)
    }

    before do
      ENV['SLACK_WEBHOOK_URL'] = 'http://slack.com'
    end

  describe 'delivery payload' do
    def from_json(str)
      ActiveSupport::JSON.decode(str)
    end
    subject { from_json(notification.deliver[:payload]) }

    it 'has the correct username' do
      expect(subject['username']).to eq('Tester')
    end

    it 'has the correct emoji icon' do
      expect(subject['icon_emoji']).to eq(':testing:')
    end

    it 'has the correct channel' do
      expect(subject['channel']).to eq('#test')
    end
  end
end
