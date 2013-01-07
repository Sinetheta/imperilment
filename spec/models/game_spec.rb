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
      before do
        2.times { create :question, answer: answer, user: user }
        Question.any_instance.stub(:value) { 200 }
      end

      it "is the sum of all values" do
        game.score(user).should == 400
      end
    end
  end
end
