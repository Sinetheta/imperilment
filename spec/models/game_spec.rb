require 'spec_helper'

describe Game do
  let(:game) { create :game }
  let(:user) { create :user }
  let(:slack_webhook_url) { 'http://slack.com' }
  let!(:mock) { stub_request(:any, slack_webhook_url) }
  before do
    ENV['SLACK_WEBHOOK_URL'] = slack_webhook_url
  end

  describe '.score' do
    let(:answer) { create :answer, game: game, amount: 400 }

    context "when no results" do
      it "is 0" do
        expect(game.score(user)).to eq(0)
      end
    end

    context "when there are results" do
      let(:answer_value) { 200 }

      before do
        2.times do
          answer = create(:answer, game: game, correct_question: correct_question, amount: answer_value)
          create :question, answer: answer, user: user, correct: true
          game.reload
        end
      end

      context "when answer has a correct_question" do
        let(:correct_question) { "Correct!" }
        it "is the sum of all values" do
          expect(game.score(user)).to eq(400)
        end

        context "when the answer is nil (final imperilment)" do
          before do
            answer = create(:answer, game: game, amount: nil, correct_question: correct_question)
            create :question, answer: answer, user: user, correct: true, amount: 200
            game.reload
          end

          context "when the game is not locked" do
            before do
              game.update!(locked: false)
            end
            it "should be the sum of all values, excluding the wager" do
              expect(game.score(user)).to eq(400)
            end
          end

          context "when the game is locked" do
            before do
              game.update!(locked: true)
            end

            it "should be the sum of all values" do
              expect(game.score(user)).to eq(600)
            end
          end
        end
      end

      context "when answer does not have a correct_question" do
        let(:correct_question) { "" }

        it "does not include any results" do
          expect(game.score(user)).to eq(0)
        end
      end
    end
  end

  describe '.max_wager' do
    let!(:unanswered) { create :answer, game: game, amount: 100 }
    let!(:answered) { create :answer, game: game, amount: 200 }
    let!(:correct) { create :answer, game: game, amount: 400 }
    let!(:incorrect) { create :answer, game: game, amount: 800 }
    let!(:final) { create :answer, game: game, amount: nil }

    before do
      create :question, user: user, answer: answered, correct: nil
      create :question, user: user, answer: correct, correct: true
      create :question, user: user, answer: incorrect, correct: false
      create :question, user: user, answer: final, correct: true, amount: 555
    end

    it 'returns the sum of all non-final, not-wrong answer amounts' do
      expect(game.max_wager(user)).to eq(700)
    end
  end

  describe '.clamp_final_wager!' do
    subject { game.clamp_final_wager!(user) }

    context 'a game without a final answer' do
      it 'does not explode' do
        is_expected.to be_nil
      end
    end

    context 'a game with a final answer but no user response for it' do
      before do
        create :answer, game: game, amount: nil
      end

      it 'does not explode' do
        is_expected.to be_nil
      end
    end

    context 'a game with a final wager for this user and a max_wager of 500' do
      let(:final_response) {
        final_nswer = create :answer, game: game, amount: nil
        build(:question, user: user, answer: final_nswer, amount: final_wager).tap do |q|
          q.save(validate: false)
        end
      }

      before do
        allow(game).to receive(:max_wager).and_return 500
      end

      context 'with final wager of 0' do
        let(:final_wager) { 0 }

        it 'does not change the final wager' do
          expect{ subject }.not_to change{ final_response.reload.amount }.from(0)
        end
      end

      context 'with final wager that is larger than the max_wager' do
        let(:final_wager) { 1000 }

        it 'reduces the final wager to the amount allowed' do
          expect{ subject }.to change{ final_response.reload.amount }.from(1000).to(500)
        end
      end
    end
  end

  describe '#all_answers' do
    context "an unsaved game" do
      let(:game) { Game.new }
      it "should have an array of 7 nil answers" do
        expect(game.all_answers).to eq [nil] * 7
      end
    end

    context "an game without answers" do
      let(:game) { create :game }
      it "should have an array of 7 nil answers" do
        expect(game.all_answers).to eq [nil] * 7
      end
    end

    context "an game with an answer" do
      let(:game) { create :game }
      let!(:answer) { create :answer, game: game, start_date: game.ended_at }
      it "should have a single anwswr padded to a week with nil" do
        expect(game.all_answers).to eq [answer, nil, nil, nil, nil, nil, nil]
      end
    end

    context "an game with multiple answers" do
      let(:game) { create :game }
      let!(:first) { create :answer, game: game, start_date: 2.days.from_now }
      let!(:second) { create :answer, game: game, start_date: 4.days.from_now }
      let!(:third) { create :answer, game: game, start_date: 3.days.from_now }

      it "returns answers in the order that they are created" do
        expect(game.all_answers).to eq [first, second, third, nil, nil, nil, nil]
      end
    end
  end

  describe '.started_on' do
    let!(:answer) { create :answer, game: game, start_date: date }
    let(:date) { Date.parse('1984-09-10') }

    subject { game.started_on }
    it { is_expected.to eq(date) }
  end

  describe '.date_range' do
    let!(:answer) { create :answer, game: game, start_date: date }
    let(:date) { Date.parse('1984-09-10') }

    before(:each) do
      game.ended_at = date + 1.day
      game.save!
    end

    subject { game.date_range }
    it { is_expected.to eq(date..(date + 1.day)) }
  end

  describe '.calculate_result!' do
    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:user3) { create :user }
    let(:user4) { create :user }

    let(:answer1) { create :answer, game: game, amount: 200 }
    let(:answer2) { create :answer, game: game, amount: 100 }

    let!(:question1) { create :question, correct: true, answer: answer1, user: user1 }
    let!(:question2) { create :question, correct: true, answer: answer2, user: user2 }
    let!(:question3) { create :question, correct: true, answer: answer2, user: user3 }
    let!(:question4) { create :question, correct: false, answer: answer2, user: user4 }

    before do
      game.reload
    end

    it 'creates 4 game results' do
      expect { game.calculate_result! }.to change { GameResult.count }.by(4)
    end

    describe 'user placement' do
      before { game.calculate_result! }
      context 'first place user' do
        it 'is in first place' do
          expect(GameResult.find_by!(user_id: user1.id).position).to eq(1)
        end
      end

      context 'second place user' do
        it 'is in second place' do
          expect(GameResult.find_by!(user_id: user3.id).position).to eq(2)
        end
      end

      context 'last place user' do
        it 'is in fourth place' do
          expect(GameResult.find_by!(user_id: user4.id).position).to eq(4)
        end
      end

      it "sends a Slack api notification" do
        expect(mock).to have_been_made
      end
    end
  end

  describe 'next and prev' do
    let!(:first) { create :game, ended_at: 2.weeks.ago }
    let!(:middle) { create :game, ended_at: 1.week.ago }
    let!(:last) { create :game, ended_at: Date.current }

    describe "first game" do
      it "has no previous" do
        expect(first.prev).to be_nil
      end
      it "has a next" do
        expect(first.next).to eq middle
      end
    end

    describe "middle game" do
      it "has a previous" do
        expect(middle.prev).to eq first
      end
      it "has a next" do
        expect(middle.next).to eq last
      end
    end

    describe "last game" do
      it "has a prev" do
        expect(last.prev).to eq middle
      end
      it "has no next" do
        expect(last.next).to be_nil
      end
    end
  end

  describe 'calculate_result hook' do
    let!(:answer) { create :answer, game: game }
    let!(:question) { create :question, answer: answer }
    it 'calculates results when locking the game' do
      game.locked = true
      expect { game.save! }.to change { GameResult.count }.by(1)
    end
  end

  describe '#grouped_and_sorted_by_score' do
    let!(:user) { create :user }
    let!(:answer) { create :answer, game: game, amount: 1 }
    let!(:question) { create :question, user: user, answer: answer, correct: true }

    before(:each) do
      game.reload
    end

    it 'should return the users grouped and sorted by score' do
      expect(game.grouped_and_sorted_by_score).to eq(1 => [user])
    end
  end

  describe '#next_answer_amount' do
    subject { game.next_answer_amount }

    context 'with a game that has no answers' do
      it { is_expected.to eq(200) }
    end

    context 'with a game that has some answers' do
      let!(:answer) { create_list :answer, 5, game: game }

      it 'suggests a value without regard for the other question amounts' do
        is_expected.to eq(2000)
      end
    end

    context 'with a game that has 6 or more questions' do
      let!(:answer) { create_list :answer, 6, game: game }

      it { is_expected.to eq(nil) }
    end
  end

  describe '#next_answer_start_date' do
    let(:game) { create :game, ended_at: '2021-12-30 00:00:00' }

    subject { game.next_answer_start_date }

    context 'with a game that has no answers' do
      it 'is 6 days earlier than the ended_at date' do
        is_expected.to eq(Date.parse('2021-12-24 00:00:00'))
      end
    end

    context 'with a game that has some answers' do
      let!(:answer) { create_list :answer, 5, game: game }

      it 'fills the week without regard for the answer start_dates' do
        is_expected.to eq(Date.parse('2021-12-29 00:00:00'))
      end
    end
  end
end
