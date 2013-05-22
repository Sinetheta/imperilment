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
        2.times { create :question, answer: create(:answer, game: game), user: user }
        Question.any_instance.stub(:value) { 200 }
      end

      context "when answer has a correct_question" do
        before { Question.any_instance.stub(:correct_question) { "Correct!" } }

        it "is the sum of all values" do
          game.score(user).should == 400
        end

        context "when the answer is nil (final imperilment)" do
          before do
            create :question, answer: create(:answer, game: game, amount:nil), user: user
          end

          context "when the game is not locked" do
            before do
              game.locked = false
            end
            it "should be the sum of all values, excluding the wager" do
              game.score(user).should == 400
            end
          end

          context "when the game is locked" do
            before do
              game.locked = true
            end

            it "should be the sum of all values" do
              game.score(user).should == 600
            end
          end
        end
      end

      context "when answer does not have a correct_question" do
        before { Question.any_instance.stub(:correct_question) { "" } }

        it "does not include any results" do
          game.score(user).should == 0
        end
      end
    end
  end

  describe '.started_on' do
    let!(:answer) { create :answer, game: game, start_date: date }
    let(:date) { Date.parse('1984-09-10') }

    subject { game.started_on }
    it { should == date }
  end

  describe '.date_range' do
    let!(:answer) { create :answer, game: game, start_date: date }
    let(:date) { Date.parse('1984-09-10') }

    before(:each) do
      game.ended_at = date + 1.day
      game.save!
    end

    subject { game.date_range }
    it { should == (date..(date + 1.day)) }
  end
end
