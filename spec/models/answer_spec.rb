require 'spec_helper'

describe Answer do
  it { is_expected.to validate_presence_of(:game) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_uniqueness_of(:start_date) }

  let!(:first) { create :answer, start_date: '2012-01-01 00:00:00' }
  let!(:second) { create :answer, start_date: '2012-01-02 00:00:00' }
  let!(:third) { create :answer, start_date: '9999-01-03 00:00:00' }

  describe '#most_recent' do
    it 'should be the one with the latest start_date before today' do
      expect(Answer.most_recent).to eq(second)
    end
  end

  describe '#last_answer' do
    it 'should return the last answer based on date' do
      expect(Answer.last_answer).to eq(third)
    end
  end

  describe '#category_name' do
    let(:answer) { build(:answer, category_name: 'category name' ) }

    it 'returns the name of the answer category' do
      expect(answer.category_name).to eq('category name')
    end
  end

  describe '#category_name=' do
    let(:answer) { create(:answer, category_name: 'category old' ) }

    it 'updates the name of the answer category' do
      answer.category_name = 'category new'
      expect(answer.category.name).to eq('category new')
    end

    it 'does not save the answer category' do
      answer.category_name = 'category new'
      answer.reload
      expect(answer.category.name).to eq('category old')
    end

    it 'ignores sentence case when searching for possible cateogry name matches' do
      create(:category, name: 'category new')
      answer.category_name = 'CaTeGoRy NeW'
      expect(answer.category.name).to eq('category new')
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

  describe '.too_soon?' do
    subject { answer.too_soon? }

    around do |e|
      travel_to(Time.parse('2021-12-28 12:00:00')) do
        e.run
      end
    end

    context 'with an answer that has a start_date which has passed' do
      let(:answer) { build(:answer, start_date: '2021-12-27') }

      it { is_expected.to eq(false) }
    end

    context 'with an answer that has a start_date today' do
      let(:answer) { build(:answer, start_date: '2021-12-28') }

      it { is_expected.to eq(false) }
    end

    context 'with an answer that has a start_date in the future' do
      let(:answer) { build(:answer, start_date: '2021-12-29') }

      it { is_expected.to eq(true) }
    end
  end
end
