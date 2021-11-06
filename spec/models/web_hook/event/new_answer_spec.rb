require 'spec_helper'

describe WebHook::Event::NewAnswer do
  let(:answer) { FactoryBot.create :answer, correct_question: 'what is fail?', category_name: 'Rails RSpec' }
  let(:event) { WebHook::Event::NewAnswer.new answer }

  describe 'serialize' do
    subject { event.serialize }

    it 'contains a link back to the answer' do
      expect(subject).to include("http://test.com/games/#{answer.game.id}/answers/#{answer.id}")
    end

    it 'does not contain the correct response' do
      expect(subject).not_to include('what is fail?')
    end

    it "contains the answer's category name" do
      expect(subject).to include('Rails RSpec')
    end
  end
end
