require 'spec_helper'

describe LeaderBoardHelper do
  describe '.rank_class' do
    subject { helper.rank_class(rank) }
    context 'when the rank is 1' do
      let(:rank) { 1 }
      it { is_expected.to eq('gold') }
    end
    context 'when the rank is 2' do
      let(:rank) { 2 }
      it { is_expected.to eq('silver') }
    end
    context 'when the rank is 3' do
      let(:rank) { 3 }
      it { is_expected.to eq('bronze') }
    end
    context 'when the rank anything else' do
      let(:rank) { 4 }
      it { is_expected.to eq('') }
    end
  end

  describe '.breakdown_icon' do
    subject { helper.breakdown_icon(result) }

    context 'unavailable' do
      let(:result){ :unavailable }
      it { is_expected.to be_blank }
    end

    context 'unanswered' do
      let(:result){ :unanswered }
      it { is_expected.to eq(helper.icon('asterisk')) }
    end

    context 'unmarked' do
      let(:result){ :unmarked }
      it { is_expected.to eq(helper.icon('minus')) }
    end

    context 'correct' do
      let(:result){ :correct }
      it { is_expected.to eq(helper.icon('check')) }
    end

    context 'incorrect' do
      let(:result){ :incorrect }
      it { is_expected.to eq(helper.icon('times')) }
    end
  end

  describe '.status_for' do
    subject { helper.status_for(answer) }
    let(:user){ double(:user) }
    before{ allow(controller).to receive(:current_user).and_return(user) }
    context 'nil answer' do
      let(:answer){ nil }
      it { is_expected.to eq(:unavailable) }
    end
    context 'nil question' do
      let(:answer){ double(:answer, question_for: nil) }
      it { is_expected.to eq(:unanswered) }
    end
    context 'nil question' do
      let(:answer){ double(:answer, question_for: question) }
      let(:question){ double(:question, status: :foobar) }
      it { is_expected.to eq(:foobar) }
    end
  end

end
