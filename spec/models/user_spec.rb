require 'spec_helper'

describe User do
  AccessToken = Struct.new(:info)

  describe "abilities" do
    subject { ability }

    let(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when user is an administrator" do
      let(:user) { create :admin }

      specify { expect(user).to have_ability(:edit, for: Game.new) }
    end
  end

  describe '.identifier' do
    let(:user) { create :user, first_name: name, email: email }
    let(:email) { 'alex.t@imperilment.com' }

    subject { user.identifier }

    context 'when the first_name is blank' do
      let(:name) { nil }
      it { is_expected.to eq(email) }
    end

    context 'when the first_name is not blank' do
      let(:name) { 'Alex' }
      it { is_expected.to eq(name) }
    end
  end

  describe '#find_for_google_oauth2' do
    let(:result) { User.find_for_google_oauth2(AccessToken.new("email" => email, "last_name" => name)) }
    let(:name) { 'Smith' }
    let(:last_name) { 'Smith' }

    context "when user exists" do
      subject { result }

      let!(:user) { create :user, last_name: last_name }
      let(:email) { user.email }

      it { is_expected.to eq(user) }
    end

    context "when user does not exist" do
      let(:email) { 'new@user.com' }

      it 'creates a user with the correct attributes' do
        expect { result }.to change { User.count }.by(1)
        expect(User.last).to have_attributes(
          email: email,
          last_name: 'S'
        )
      end
    end
  end

  describe "#pending_answers" do
    let!(:user) { create :user }
    let!(:game) { create :game }
    let!(:answer) { create :answer, game: game }
    subject { user.pending_answers }

    context "Answer has question from same user" do
      let!(:question) { create :question, answer: answer, user: user }
      it { is_expected.to eq [] }
    end
    context "Answer has question from other user" do
      let!(:question) { create :question, answer: answer }
      it { is_expected.to eq [answer] }
    end
    context "Game is locked" do
      let!(:game) { create :game, locked: true }
      it { is_expected.to eq [] }
    end
    context "one unanswered question" do
      it { is_expected.to eq [answer] }
    end
    context "two unanswered questions in one game" do
      let(:answer2) { create :answer, game: game }
      it { is_expected.to eq [answer, answer2] }
    end
    context "two unanswered questions across games" do
      let(:answer2) { create :answer }
      it { is_expected.to eq [answer, answer2] }
    end
  end

  describe "#correct_ratio" do
    let(:user) { create :user }

    context "without provided season" do
      let(:game) { create :game }
      let(:answer) { create :answer, game: game }
      subject { user.correct_ratio }

      context "with all-correct questions" do
        let!(:question) { create :question, user: user, answer: answer, correct: true }
        it { is_expected.to eq 1.0 }
      end

      context "with no questions" do
        it { is_expected.to eq 0.0 }
      end
    end

    context "with provided season" do
      let(:season) { Season.new(1.year.ago.year) }
      before do
        travel_to(season.date_range.begin) do
          game = create :game, ended_at: Time.now

          answer1 = create :answer, game: game
          answer2 = create :answer, game: game

          create :question, user: user, answer: answer1, correct: true
          create :question, user: user, answer: answer2, correct: false
        end
      end

      subject { user.correct_ratio(season) }

      it { is_expected.to eq 0.5 }
    end
  end
end
