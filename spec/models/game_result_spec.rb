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

  describe '::all_results_by_money' do
    before do
      GameResult.create! user_id: 1, position: 1, total: 1
      GameResult.create! user_id: 1, position: 3, total: 1
      GameResult.create! user_id: 1, position: 5, total: 1
      GameResult.create! user_id: 2, position: 1, total: 1
      GameResult.create! user_id: 2, position: 3, total: 1
      GameResult.create! user_id: 4, position: 3, total: 5
      # This user shouldn't appear in the results, as they have no total
      GameResult.create! user_id: 3, position: 10, total: 0
    end

    it 'sorts users by total money' do
      results = GameResult.all_results_by_money.map! do |result|
        { result.user_id => result.total }
      end
      expect(results).to eql [{4 => 5}, {1 => 3}, {2 => 2}]
    end
  end

  describe 'results' do
    let(:answers){ [answer, nil] }
    let(:answer){ double(:answer, start_date: 1) }
    let(:question){ nil }
    let(:game){ double(:game, date_range: [1,2], all_answers: answers) }
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

    context 'answered' do
      let(:question){ double(:question, status: :questionstatus) }
      it { should == [:questionstatus, :unavailable] }
    end
  end

  describe 'percentage_correct' do
    let(:start_date){ Date.new(2012, 1, 1) }
    let(:user){ User.new }
    let(:game){ Game.new answers: answers, ended_at: start_date + 1.week }
    let(:game_result){ GameResult.new(user: user, game: game) }

    def answer correct
      @date ||= start_date
      Answer.new do |a|
        a.start_date = @date
        a.questions.new do |q|
          q.user = user
          q.correct = correct
        end
        @date += 1.day
      end
    end

    subject { game_result.percentage_correct }

    context 'with no answers' do
      let(:answers){ [] }
      it{ should == 0 }
    end

    context 'with one unanswered answer' do
      let(:answers){ [answer(nil)] }
      it{ should == 0 }
    end

    context 'with one incorrect answer' do
      let(:answers){ [answer(false)] }
      it{ should == 0 }
    end

    context 'with one correct answer' do
      let(:answers){ [answer(true)] }
      it{ should == 100 }
    end

    context 'with one correct answer, one unanswered' do
      let(:answers){ [answer(true), answer(nil)] }
      it{ should == 100 }
    end

    context 'with one correct answer, one incorrect' do
      let(:answers){ [answer(true), answer(false)] }
      it{ should == 50 }
    end
  end
end
