require 'spec_helper'

describe Answer do
  it { should validate_presence_of(:game_id) }
  it { should validate_presence_of(:category_id) }
  it { should validate_presence_of(:start_date) }
  it { should validate_uniqueness_of(:start_date) }

  let!(:first) { create :answer, start_date: '2013-01-01 00:00:00' }
  let!(:second) { create :answer, start_date: '2013-01-02 00:00:00' }
  let!(:third) { create :answer, start_date: '9999-01-03 00:00:00' }

  describe '#most_recent' do
    it 'should be the one with the latest start_date before today' do
      Answer.most_recent.should == second
    end
  end

  describe '.on' do
    it 'should find the answer with the matching date' do
      Answer.on(first.start_date).should == first
    end
  end

  describe '.prev' do
    context "when prevous record exists" do
      it 'should find the one before this one by start date' do
        second.prev.should == first
      end
    end

    context "when previous record does not exist" do
      it 'returns nil' do
        first.prev.should be_nil
      end
    end
  end

  describe '.next' do
    context "when next record exists" do
      it 'should find the one after this one by start date' do
        second.next.should == third
      end
    end

    context "when next record does not exist" do
      it 'returns nil' do
        third.next.should be_nil
      end
    end
  end

  describe '.closed' do
    subject { first.closed? }

    context "when correct_question is nil" do
      before { first.correct_question = nil }
      it { should be_false }
    end

    context "when correct_question is the empty string" do
      before { first.correct_question = "" }
      it { should be_false }
    end

    context "when correct_question is some text" do
      before { first.correct_question = "Question" }
      it { should be_true }
    end
  end
end
