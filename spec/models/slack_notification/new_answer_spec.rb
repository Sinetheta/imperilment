require 'spec_helper'

class NoOpHTTPClient
  def self.post uri, params={}
    params # return params so that we can inspect the payload intended for Slack
  end
end

RSpec.describe SlackNotification::NewAnswer, type: :model do
  let(:answer) { FactoryGirl.create :answer,
    id: 829,
    answer: 'What is fail?',
    category_name: 'Rails RSpec',
    amount: 200
  }
  let(:notification) { SlackNotification::NewAnswer.new(answer, http_client: NoOpHTTPClient) }

  before do
    ENV['SLACK_WEBHOOK_URL'] = 'http://slack.com'
  end

  describe 'delivery payload' do
    def from_json(str)
      ActiveSupport::JSON.decode(str)
    end
    subject { from_json(notification.deliver[:payload]) }

    it 'has the corract attachments' do
      expect(subject['attachments']).to eq [{
        'pretext' => 'New Imperilment clue!',
        'title' => 'Rails RSpec for $200',
        'title_link' => 'http://test.com/games/1/answers/829',
        'text' => 'What is fail?',
        'color' => '#337AB7',
        'fallback' => 'New Imperilment clue! http://test.com/games/1/answers/829'
      }]
    end

    context "when answer has no amount" do
      let(:answer) do
        FactoryGirl.create(
          :answer,
          id: 829,
          answer: nil,
          category_name: 'Rails RSpec',
          amount: nil
        )
      end

      it 'has the corract attachments' do
        expect(subject['attachments']).to eq [{
          'pretext' => 'Final Imperilment!',
          'title' => 'Rails RSpec',
          'title_link' => 'http://test.com/games/1/answers/829',
          'text' => nil,
          'color' => '#337AB7',
          'fallback' => 'Final Imperilment! http://test.com/games/1/answers/829'
        }]
      end
    end
  end
end
