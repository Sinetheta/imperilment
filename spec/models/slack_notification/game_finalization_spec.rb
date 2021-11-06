require 'spec_helper'

class NoOpHTTPClient
  def self.post uri, params={}
    params # return params so that we can inspect the payload intended for Slack
  end
end

RSpec.describe SlackNotification::GameFinalization, type: :model do
  let(:game) { FactoryBot.create :game, id: 772 }
  let(:first_place) { FactoryBot.create :user, first_name: 'First', last_name: 'P' }
  let(:no_name) {     FactoryBot.create :user, email: 'foo@bar.com' }
  let(:tied_for_2) {  FactoryBot.create :user, first_name: 'Also', last_name: '2' }
  before do
    FactoryBot.create :game_result, game: game, position: 1, total: '4200', user: first_place
    FactoryBot.create :game_result, game: game, position: 2, total: '2500', user: no_name
    FactoryBot.create :game_result, game: game, position: 2, total: '2500', user: tied_for_2
  end

  let(:notification) { SlackNotification::GameFinalization.new(game, http_client: NoOpHTTPClient) }

  before do
    ENV['SLACK_WEBHOOK_URL'] = 'http://slack.com'
  end

  describe 'delivery payload' do
    def from_json(str)
      ActiveSupport::JSON.decode(str)
    end
    subject { from_json(notification.deliver.first[:payload]) }

    it 'has the correct attachments' do
      expect(subject['attachments']).to eq [{
        'pretext' => 'Imperilment results are in!',
        'title' => "Last week's winners",
        'title_link' => 'http://test.com/leader_board/772',
        'text' => ":trophy: $4200 First P\n\n:silver: $2500 foo@bar.com\n\n:silver: $2500 Also 2",
        'color' => '#337AB7',
        'fallback' => "Last week's winners are in! http://test.com/leader_board/772"
      }]
    end
  end
end
