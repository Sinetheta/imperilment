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
      let(:answer_value){ 200 }

      before do
        2.times do
          answer = create(:answer, game: game, correct_question: correct_question, amount: answer_value)
          create :question, answer: answer, user: user, correct: true
        end
      end

      context "when answer has a correct_question" do
        let(:correct_question){ "Correct!" }
        it "is the sum of all values" do
          game.score(user).should == 400
        end

        context "when the answer is nil (final imperilment)" do
          before do
            answer = create(:answer, game: game, amount: nil, correct_question: correct_question)
            create :question, answer: answer, user: user, correct: true, amount: 200
          end

          context "when the game is not locked" do
            before do
              game.update!(locked: false)
            end
            it "should be the sum of all values, excluding the wager" do
              game.score(user).should == 400
            end
          end

          context "when the game is locked" do
            before do
              game.update!(locked: true)
            end

            it "should be the sum of all values" do
              game.score(user).should == 600
            end
          end
        end
      end

      context "when answer does not have a correct_question" do
        let(:correct_question){ "" }

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

  describe '.calculate_result!' do
    before do
      # FIXME - Don't stub methods no what you're testing
      game.stub(:grouped_and_sorted_by_score) { { 200 => [User.new(id: 1)], 100 => [User.new(id: 2), User.new(id: 3)], 0 => [User.new(id: 4)]} }
    end

    it 'creates 4 game results' do
      expect { game.calculate_result! }.to change{GameResult.count}.by(4)
    end

    describe 'user placement' do
      before { game.calculate_result! }
      context 'first place user' do
        it 'is in first place' do
          GameResult.find_by!(user_id: 1).position.should == 1
        end
      end

      context 'second place user' do
        it 'is in second place' do
          GameResult.find_by!(user_id: 3).position.should == 2
        end
      end

      context 'last place user' do
        it 'is in fourth place' do
          GameResult.find_by!(user_id: 4).position.should == 4
        end
      end
    end
  end

  describe 'calculate_result hook' do
    before do
      # FIXME - Don't stub methods no what you're testing
      game.stub(:grouped_and_sorted_by_score) { { 200 => [User.new(id: 1)] } }
    end

    it 'calculates results when locking the game' do
      game.locked = true
      expect { game.save! }.to change{GameResult.count}.by(1)
    end
  end

  describe '#grouped_and_sorted_by_score' do
    let(:user) { create :user }

    before(:each) do
      game.stub(:users) { [user] }
      game.stub(:score) { 1 }
    end

    it 'should return the users grouped and sorted by score' do
      game.grouped_and_sorted_by_score.should == {1 => [user]}
    end
  end
end
