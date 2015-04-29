require 'spec_helper'

describe WebHook::Event::NewQuestion do
  let(:question) do
    FactoryGirl.build_stubbed :question,
      response: "a secret",
      answer: FactoryGirl.create(:answer, answer: "Such clue"),
      user: FactoryGirl.build(:user, email: "my@email.com")
  end
  let(:event) { WebHook::Event::NewQuestion.new question }

  describe 'serialize' do
    subject { event.serialize }

    it "contains the question's answer" do
      expect(subject).to include('Such clue')
    end

    it "contains the user's email" do
      expect(subject).to include('my@email.com')
    end

    it "does not contain the user's response" do
      expect(subject).not_to include('a secret')
    end
  end
end
