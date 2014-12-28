require 'spec_helper'

describe Question do

  context 'when a question and its answer have no value' do
    let(:question) { build :question, amount: nil}
    subject { question }
    before(:each) do
      question.answer.amount = nil
    end
    it { is_expected.not_to be_valid }
  end

  context 'when a question for an answer already exists' do
    let(:answer) { build :answer }
    let(:user) { build :user }

    before(:each) { create :question, answer: answer, user: user }

    let(:question) { build :question, answer: answer, user: user }
    specify { expect(question).not_to be_valid }
  end

  describe '.checked?' do
    let(:question) { create :question }
    subject { question.checked? }

    context 'when a question has been checked' do
      before(:each) do
        question.correct = false
        question.save!
      end
      it { is_expected.to be_truthy }
    end

    context 'when a question has not been checked' do
      it { is_expected.to be_falsey }
    end
  end

  describe '.status' do
    let(:question) { build_stubbed :question, correct: correct }
    subject{ question.status }
    context 'unmarked' do
      let(:correct){ nil }
      it { is_expected.to eq(:unmarked) }
    end
    context 'correct' do
      let(:correct){ true }
      it { is_expected.to eq(:correct) }
    end
    context 'incorrect' do
      let(:correct){ false }
      it { is_expected.to eq(:incorrect) }
    end
  end

  describe '.value' do
    let(:question) { create :question, correct: correct }
    let(:amount) { 200 }

    subject { question.value }

    context "when question is a wager" do
      before do
        question.answer.amount = nil
        question.amount = amount
      end

      context "when correct" do
        let(:correct) { true }
        it { is_expected.to eq(amount) }
      end

      context "when not correct" do
        let(:correct) { false }
        it { is_expected.to eq(-amount) }
      end

      context "when not correct or incorrect" do
        let(:correct) { nil }
        it { is_expected.to eq(0) }
      end
    end

    context "when question is not a wager" do
      before { question.answer.amount = amount }

      context "when correct" do
        let(:correct) { true }
        it { is_expected.to eq(amount) }
      end

      context "when not correct" do
        let(:correct) { false }
        it { is_expected.to eq(0) }
      end
    end
  end

  describe '.valid?' do
    let(:game) { stub_model Game }
    let(:answer) { stub_model Answer, game: game, amount: nil }
    let(:question_amount) { nil }
    let(:question) { build :question, answer: answer, amount: question_amount }

    subject { question.valid? }
    context 'when amounts are in range' do
      before(:each) { allow(question).to receive(:in_range?) { true } }
      context 'when question and answer amounts are nil' do
        it { is_expected.to be_falsey }
      end
      context 'when question amount is not nil' do
        let(:question_amount) { 100 }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe '.in_range?' do
    let(:game) { stub_model Game }
    let(:answer) { stub_model Answer, game: game }
    let(:question) { build :question, answer: answer, amount: nil }

    subject { question.in_range? }

    context 'when the amount is nil' do
      it { is_expected.to be_truthy }
    end

    context 'when the amount is not nil' do
      before(:each) do
        allow(game).to receive(:score) { 200 }

        question.amount = amount
      end

      context 'and outside the range' do
        let(:amount) { -100 }

        it { is_expected.to be_falsey }
      end

      context 'and within the range' do
        let(:amount) { 100 }

        it { is_expected.to be_truthy }
      end
    end
  end
end
