require 'spec_helper'
require 'timecop'

describe Answer do
  it { is_expected.to validate_presence_of(:game) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_uniqueness_of(:start_date) }

  let!(:first) { create :answer, start_date: '2013-01-01 00:00:00' }
  let!(:second) { create :answer, start_date: '2013-01-02 00:00:00' }
  let!(:third) { create :answer, start_date: '9999-01-03 00:00:00' }

  describe '#most_recent' do
    it 'should be the one with the latest start_date before today' do
      expect(Answer.most_recent).to eq(second)
    end
  end

  describe '#next_free_date' do
    let(:date) { Date.new(9999, 1, 4) }
    subject { Answer.next_free_date }

    context 'when there is atleast one previous answer' do
      it 'should be equal to the day after the third answer' do
        is_expected.to eq(date)
      end
    end

    context 'when there are no previous answers' do
      before do
        Answer.destroy_all
        Timecop.freeze
      end
      after do
        Timecop.return
      end
      it { is_expected.to eq(Date.today) }
    end
  end

  describe '#last_answer' do
    it 'should return the last answer based on date' do
      expect(Answer.last_answer).to eq(third)
    end
  end

  describe '.closed' do
    subject { first.closed? }

    context "when correct_question is nil" do
      before { first.correct_question = nil }
      it { is_expected.to be_falsey }
    end

    context "when correct_question is the empty string" do
      before { first.correct_question = "" }
      it { is_expected.to be_falsey }
    end

    context "when correct_question is some text" do
      before { first.correct_question = "Question" }
      it { is_expected.to be_truthy }
    end
  end

  describe '.active?' do
    let!(:sat_answer) { create :answer, start_date: '2016-08-13 00:00:00' }
    let!(:sun_answer) { create :answer, start_date: '2016-08-14 00:00:00' }
    let!(:today_answer) { create :answer, start_date: Date.current }
    let!(:tom_answer) { create :answer, start_date: Date.tomorrow }

    context "when the answer is active" do
      subject { first }
      it { is_expected.to be_active }
    end

    context "when the answer is inactive" do
      subject { third }
      it { is_expected.not_to be_active }
    end

    context "when the answer is for a Saturday" do
      subject { sat_answer.active? }
      it "should be active on Friday" do
        Timecop.freeze(Time.zone.local(2016, 8, 12, 0, 0, 0)) do
          expect(sat_answer).to be_active
        end
      end

      it "should be active on Saturday" do
        Timecop.freeze(Time.zone.local(2016, 8, 13, 0, 0, 0)) do
          expect(sat_answer).to be_active
        end
      end
    end

    context "when the answer is for a Sunday" do
      it "should be inactive on Sunday" do
        Timecop.freeze(Time.zone.local(2016, 8, 14, 0, 0, 0)) do
          expect(sun_answer).not_to be_active
        end
      end

      it "should be active on Monday" do
        Timecop.freeze(Time.zone.local(2016, 8, 15, 0, 0, 0)) do
          expect(sun_answer).to be_active
        end
      end
    end

    context "when the answer is for today" do
      subject { today_answer }
      it { is_expected.to be_active }
    end

    context "when today is in the afternoon" do
      it "tomorrow's answer should be inactive" do
        Timecop.freeze(Time.zone.local(Time.zone.now.year, Time.zone.now.month,
                                       Time.zone.now.day, 22, 0, 0))
        expect(tom_answer).not_to be_active
      end
    end
  end
end
