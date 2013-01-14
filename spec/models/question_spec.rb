require 'spec_helper'

describe Question do
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

  describe '.in_range?' do
    let(:game) { stub_model Game }
    let(:answer) { stub_model Answer }
    let(:question) { build :question, answer: answer, amount: nil }

    context 'when the amount is nil' do
      it 'should persist the question' do
        question.save.should be_true
      end
    end

    context 'when the amount is not nil' do
      before(:each) do
        answer.stub(:game) { game }
        game.stub(:score) { 200 }

        question.amount = amount
      end

      context 'and outside the range' do
        let(:amount) { -100 }

        it 'should not persist the question' do
          question.save.should be_false
        end
      end

      context 'and within the range' do
        let(:amount) { 100 }

        it 'should persist the question' do
          question.save.should be_true
        end
      end
    end
  end
end
