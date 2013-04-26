require 'spec_helper'

describe LeaderBoardHelper do
  describe '.rank_class' do
    subject { helper.rank_class(rank) }
    context 'when the rank is 0' do
      let(:rank) { 0 }
      it { should == 'gold' }
    end
    context 'when the rank is 1' do
      let(:rank) { 1 }
      it { should == 'silver' }
    end
    context 'when the rank is 2' do
      let(:rank) { 2 }
      it { should == 'bronze' }
    end
    context 'when the rank anything else' do
      let(:rank) { 3 }
      it { should == '' }
    end
  end

  describe '.breakdown_icon' do
    let(:user) { create :user }
    let(:game) { create :game }
    let(:date) { Date.parse('1984-09-10') }

    subject { helper.breakdown_icon(game, user, date) }

    context 'when there is no answer' do
      it { should be_blank }
    end

    context' when there is an answer' do
      let!(:answer) { create :answer, game: game, start_date: date }

      context 'when there is no question' do
        it { should == helper.icon('asterisk') }
      end

      context 'when there is a question' do
        let!(:question) { create :question, user: user, answer: answer, correct: correct }

        context 'when the question is correct' do
          let(:correct) { true }
          it { should == helper.icon('ok') }
        end

        context 'when the question is incorrect' do
          let(:correct) { false }
          it { should == helper.icon('remove') }
        end

        context 'when the question has not been checked' do
          let(:correct) { nil }
          it { should == helper.icon('minus') }
        end
      end
    end
  end

  describe '.breakdown_link' do
    let(:game) { create :game }
    let(:date) { Date.parse('1984-09-10') }

    subject { helper.breakdown_link(game, date) }

    context 'when there is no answer' do
      it { should == 'javascript:;' }
    end

    context' when there is an answer' do
      let!(:answer) { create :answer, game: game, start_date: date }
      it { should == game_answer_path(game, answer) }
    end
  end
end
