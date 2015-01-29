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
    let(:result) { User.find_for_google_oauth2(AccessToken.new({ "email" => email, "last_name" => name })) }
    let(:name) { 'Smith' }

    context "when user exists" do
      subject { result }

      let!(:user) { create :user, last_name: last_name }
      let(:email) { user.email }
      let(:last_name) { 'Smith' }

      context "when the user's last_name is blank" do
        let(:last_name) { nil }

        describe '#last_name' do
          subject { super().last_name }
          it { is_expected.to eq(name[0]) }
        end
      end

      context "when the user's last_name is not blank" do
        subject { ->{result} }
        it { is_expected.not_to change(user, :last_name) }
      end

      it { is_expected.to eq(user) }
    end

    context "when user does not exist" do
      let(:email) { 'new@user.com' }

      it 'creates a user' do
        expect { result }.to change{User.count}.by(1)
      end
    end
  end

  RSpec.shared_context "shared percentage setup" do
    let(:user) { create :user }
    let(:game) { create :game }
    let(:answer1) { create :answer, game: game }
    let(:answer2) { create :answer, game: game }
    let(:answer3) { create :answer }
    let!(:question1) { create :question, correct: false, user: user, answer: answer1 }
    let!(:question2) { create :question, correct: true, user: user, answer: answer2 }
    let!(:question3) { create :question, correct: true, user: user, answer: answer3 }
  end

  describe ".percentage_correct_by_game" do
    include_context "shared percentage setup"
    let(:game_percentage) { 50.0 }
    before do
      game.update!(ended_at: game.started_on + 1.week)
      game.reload # Needed to have all the answers loaded
    end
    let(:game_result) { GameResult.new(user: user, game: game) }

    it "returns the percentage of the game's questions that the user correctly answered" do
      expect(game_result.percentage_correct).to eql game_percentage
    end
  end

  describe "#pending_answers" do
    let!(:user){ create :user }
    let!(:game){ create :game }
    let!(:answer){ create :answer, game: game }
    subject{ user.pending_answers }

    context "Answer has question from same user" do
      let!(:question){ create :question, answer: answer, user: user }
      it{ is_expected.to eq [] }
    end
    context "Answer has question from other user" do
      let!(:question){ create :question, answer: answer }
      it{ is_expected.to eq [answer] }
    end
    context "Game is locked" do
      let!(:game){ create :game, locked: true }
      it{ is_expected.to eq [] }
    end
    context "one unanswered question" do
      it{ is_expected.to eq [answer] }
    end
    context "two unanswered questions in one game" do
      let(:answer2){ create :answer, game: game }
      it{ is_expected.to eq [answer, answer2] }
    end
    context "two unanswered questions across games" do
      let(:answer2){ create :answer }
      it{ is_expected.to eq [answer, answer2] }
    end
  end
end
