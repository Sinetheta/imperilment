require 'spec_helper'

describe LeaderBoardHelper do
  describe '.rank_class' do
    subject { helper.rank_class(rank) }
    context 'when the rank is 1' do
      let(:rank) { 1 }
      it { should == 'gold' }
    end
    context 'when the rank is 2' do
      let(:rank) { 2 }
      it { should == 'silver' }
    end
    context 'when the rank is 3' do
      let(:rank) { 3 }
      it { should == 'bronze' }
    end
    context 'when the rank anything else' do
      let(:rank) { 4 }
      it { should == '' }
    end
  end

  describe '.breakdown_icon' do
    subject { helper.breakdown_icon(result) }

    context 'unavailable' do
      let(:result){ :unavailable }
      it { should be_blank }
    end

    context 'unanswered' do
      let(:result){ :unanswered }
      it { should == helper.icon('asterisk') }
    end

    context 'unmarked' do
      let(:result){ :unmarked }
      it { should == helper.icon('minus') }
    end

    context 'correct' do
      let(:result){ :correct }
      it { should == helper.icon('check') }
    end

    context 'incorrect' do
      let(:result){ :incorrect }
      it { should == helper.icon('times') }
    end
  end

  describe '.status_for' do
    subject { helper.status_for(answer) }
    let(:user){ double(:user) }
    before{ controller.stub(current_user: user) }
    context 'nil answer' do
      let(:answer){ nil }
      it { should == :unavailable }
    end
    context 'nil question' do
      let(:answer){ double(:answer, question_for: nil) }
      it { should == :unanswered }
    end
    context 'nil question' do
      let(:answer){ double(:answer, question_for: question) }
      let(:question){ double(:question, status: :foobar) }
      it { should == :foobar }
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
