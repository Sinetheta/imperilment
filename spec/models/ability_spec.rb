require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  let(:user) { build_stubbed :user }
  let(:ability) { Ability.new(user) }

  subject { ability }

  context 'when user has admin privileges' do
    before(:each) { allow(user).to receive(:has_role?).with(:admin) { true } }
    it { is_expected.to be_able_to :manage, :all }

    context 'when user has not responded to an answer' do
      let(:answer) { build_stubbed :answer }
      before(:each) { allow(answer).to receive(:question_for) { nil } }

      it { is_expected.not_to be_able_to :check, answer }
    end
  end

  context 'when user is not an administrator' do
    it { is_expected.to be_able_to :index, Question }
    it { is_expected.to be_able_to :read, Game }
    it { is_expected.to be_able_to :read, Answer }

    describe 'managing questions' do
      context 'when question is for user' do
        let(:question) { build_stubbed :question, user: user  }
        it { is_expected.to be_able_to :manage, question }

        context 'before we reach the question start_date' do
          before do
            question.answer = build_stubbed :answer, start_date: Date.tomorrow
          end

          it { is_expected.not_to be_able_to :manage, question }
        end

        context 'after we reach the question start_date' do
          before do
            question.answer = build_stubbed :answer, start_date: Date.current
          end

          it { is_expected.to be_able_to :manage, question }
        end
      end

      context 'when question is not for user' do
        let(:question) { build_stubbed :question }
        it { is_expected.not_to be_able_to :manage, question }
      end

      it { is_expected.not_to be_able_to :check, Answer }
    end

    context "when question's answer is closed" do
      let(:question) { build_stubbed :question }
      before(:each) { allow(question.answer).to receive(:closed?) { true } }
      it { is_expected.to be_able_to :show, question }
    end

    context "when question's answer is not closed" do
      let(:question) { build_stubbed :question }
      before(:each) { allow(question.answer).to receive(:closed?) { false } }
      it { is_expected.not_to be_able_to :show, question }
    end
  end
end
