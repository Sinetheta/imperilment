require 'spec_helper'

describe GameResult do
  describe '::all_results' do
    before do
      user1 = create :user
      user2 = create :user
      user3 = create :user

      GameResult.create! user: user1, position: 1, total: 1
      GameResult.create! user: user1, position: 3, total: 1
      GameResult.create! user: user1, position: 3, total: 1
      GameResult.create! user: user1, position: 5, total: 1
      GameResult.create! user: user2, position: 1, total: 1
      # This user shouldn't appear in the results, as they have no total
      GameResult.create! user: user3, position: 10, total: 0
    end

    describe 'user 1' do
      subject { GameResult.all_results }

      specify { expect(subject.first.first).to eq(1) }
      specify { expect(subject.first.second).to eq(0) }
      specify { expect(subject.first.third).to eq(2) }
      specify { expect(subject.last.first).to eq(1) }
      specify { expect(subject.last.second).to eq(0) }
      specify { expect(subject.last.third).to eq(0) }
    end
  end

  describe '::all_results_by_money' do
    before do
      user1 = create :user
      user2 = create :user
      user3 = create :user
      user4 = create :user

      GameResult.create! user: user1, position: 1, total: 1
      GameResult.create! user: user1, position: 3, total: 1
      GameResult.create! user: user1, position: 5, total: 1
      GameResult.create! user: user2, position: 1, total: 1
      GameResult.create! user: user2, position: 3, total: 1
      GameResult.create! user: user4, position: 3, total: 5
      # This user shouldn't appear in the results, as they have no total
      GameResult.create! user: user3, position: 10, total: 0
    end

    it 'sorts users by total money' do
      results = GameResult.all_results_by_money.map do |result|
        { result.id => result.total }
      end
      expect(results).to eql [{ 4 => 5 }, { 1 => 3 }, { 2 => 2 }]
    end
  end

  describe 'results' do
    let(:answers) { [answer, nil] }
    let(:answer) { double(:answer, start_date: 1) }
    let(:question) { nil }
    let(:game) { double(:game, date_range: [1, 2], all_answers: answers) }
    let(:user) { User.new }
    let(:game_result) { described_class.new(user: user, total: 1000, position: 2) }

    subject { game_result.results }

    before do
      allow(game_result).to receive(:game).and_return(game)
      allow(answer).to receive(:question_for).with(user) { question }
    end

    context 'unanswered' do
      it { is_expected.to eq([:unanswered, :unavailable]) }
    end

    context 'answered' do
      let(:question) { double(:question, status: :questionstatus) }
      it { is_expected.to eq([:questionstatus, :unavailable]) }
    end
  end
end
