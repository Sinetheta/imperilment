require 'spec_helper'

describe Question do

  context 'when a question and its answer have no value' do
    let(:question) { build :question, amount: nil}
    subject { question }
    before(:each) do
      question.answer.amount = nil
    end
    it { should_not be_valid }
  end

  context 'when a question for an answer already exists' do
    let(:answer) { build :answer }
    let(:user) { build :user }

    before(:each) { create :question, answer: answer, user: user }

    let(:question) { build :question, answer: answer, user: user }
    specify { question.should_not be_valid }
  end

  describe '.checked?' do
    let(:question) { create :question }
    subject { question.checked? }

    context 'when a question has been checked' do
      before(:each) do
        question.correct = false
        question.save!
      end
      it { should be_true }
    end

    context 'when a question has not been checked' do
      it { should be_false }
    end
  end

  describe '.status' do
    let(:question) { build_stubbed :question, correct: correct }
    subject{ question.status }
    context 'unmarked' do
      let(:correct){ nil }
      it { should == :unmarked }
    end
    context 'correct' do
      let(:correct){ true }
      it { should == :correct }
    end
    context 'incorrect' do
      let(:correct){ false }
      it { should == :incorrect }
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
        it { should == amount }
      end

      context "when not correct" do
        let(:correct) { false }
        it { should == (-amount) }
      end

      context "when not correct or incorrect" do
        let(:correct) { nil }
        it { should == 0 }
      end
    end

    context "when question is not a wager" do
      before { question.answer.amount = amount }

      context "when correct" do
        let(:correct) { true }
        it { should == amount }
      end

      context "when not correct" do
        let(:correct) { false }
        it { should == 0 }
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
      before(:each) { question.stub(:in_range?) { true } }
      context 'when question and answer amounts are nil' do
        it { should be_false }
      end
      context 'when question amount is not nil' do
        let(:question_amount) { 100 }
        it { should be_true }
      end
    end
  end

  describe '.in_range?' do
    let(:game) { stub_model Game }
    let(:answer) { stub_model Answer, game: game }
    let(:question) { build :question, answer: answer, amount: nil }

    subject { question.in_range? }

    context 'when the amount is nil' do
      it { should be_true }
    end

    context 'when the amount is not nil' do
      before(:each) do
        game.stub(:score) { 200 }

        question.amount = amount
      end

      context 'and outside the range' do
        let(:amount) { -100 }

        it { should be_false }
      end

      context 'and within the range' do
        let(:amount) { 100 }

        it { should be_true }
      end
    end
  end
end
