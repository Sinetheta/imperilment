require 'spec_helper'

describe WebHook::Event::NewQuestion do
  let(:question) do
    FactoryBot.build_stubbed :question,
      response: "a secret",
      answer: FactoryBot.create(:answer, answer: "Such clue"),
      user: FactoryBot.build(:user, email: "my@email.com")
  end
  let(:event) { WebHook::Event::NewQuestion.new question }

  describe 'serialize' do
    subject { event.serialize }

    it "contains the question's answer" do
      expect(subject).to include('Such clue')
    end

    it "does not contain the user's email" do
      expect(subject).not_to include('my@email.com')
    end

    it "contains a display_name for the user" do
      expect(subject).to include('Anonymous')
    end

    it "does not contain the user's response" do
      expect(subject).not_to include('a secret')
    end
  end
end
