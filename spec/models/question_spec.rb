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
end
