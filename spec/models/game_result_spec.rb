require 'spec_helper'

describe GameResult do
  describe '::all_results' do
    before do
      GameResult.create! user_id: 1, position: 1, total: 1
      GameResult.create! user_id: 1, position: 3, total: 1
      GameResult.create! user_id: 1, position: 3, total: 1
      GameResult.create! user_id: 1, position: 5, total: 1
      GameResult.create! user_id: 2, position: 1, total: 1
      # This user shouldn't appear in the results, as they have no total
      GameResult.create! user_id: 3, position: 10, total: 0
    end

    describe 'user 1' do
      subject { GameResult.all_results }

      specify { subject.first.first.should == 1 }
      specify { subject.first.second.should == 0 }
      specify { subject.first.third.should == 2 }
      specify { subject.last.first.should == 1 }
      specify { subject.last.second.should == 0 }
      specify { subject.last.third.should == 0 }
    end
  end

  describe 'results' do
    let(:answers){ [answer] }
    let(:answer){ double(:answer, start_date: 1) }
    let(:question){ nil }
    let(:game){ double(:game, date_range: [1,2], answers: answers) }
    let(:user){ User.new }
    let(:game_result){ described_class.new(user: user, total: 1000, position: 2) }

    subject{ game_result.results }

    before do
      game_result.stub(:game).and_return(game)
      answer.stub(:question_for).with(user).and_return{question}
    end

    context 'unanswered' do
      it { should == [:unanswered, :unavailable] }
    end

    context 'correct' do
      let(:question){ double(:question, correct: true) }
      it { should == [:correct, :unavailable] }
    end
    context 'incorrect' do
      let(:question){ double(:question, correct: false) }
      it { should == [:incorrect, :unavailable] }
    end
    context 'unmarked' do
      let(:question){ double(:question, correct: nil) }
      it { should == [:unmarked, :unavailable] }
    end
  end

end
