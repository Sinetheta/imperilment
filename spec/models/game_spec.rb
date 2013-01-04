require 'spec_helper'

describe Game do
  let(:game) { create :game }
  let(:user) { create :user }

  describe '.score' do
    let(:answer) { create :answer, game: game, amount: 400 }

    context "when no results" do
      it "is 0" do
        game.score(user).should == 0
      end
    end

    context "when there are results" do
      let!(:correct_response) { create :question, answer: answer, user: user, correct: true }
      let!(:incorrect_response) { create :question, answer: answer, user: user, correct: false }

      it "is the sum of all correct responses" do
        game.score(user).should == 400
      end
    end
  end
end
