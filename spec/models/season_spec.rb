require 'spec_helper'

describe Season do
  let(:season) { Season.new(year) }

  def date(s)
    Date.parse(s)
  end

  shared_examples "ISO 8601 week based date range" do
    let(:first_day) { subject.begin.to_date }
    let(:last_day) { subject.end.to_date }

    it "starts on the first week of the year" do
      expect(first_day.cwyear).to eq(year)
      expect(first_day.cweek).to eq(1)
    end

    it "ends on a week of the same year" do
      expect(last_day.cwyear).to eq(year)
    end

    it "starts immediately after the last week of previous year" do
      prev_day = first_day - 1.day
      expect(prev_day.cwyear).to eq(year - 1)
    end

    it "ends immediately before the first week of the following year" do
      next_day = last_day + 1.day
      expect(next_day.cwyear).to eq(year + 1)
      expect(next_day.cweek).to eq(1)
    end
  end

  describe '#date_range' do
    subject { season.date_range }
    context '2014' do
      let(:year) { 2014 }

      it_behaves_like "ISO 8601 week based date range"

      it { should cover(date("2014-01-01")) }
      it { should cover(date("2014-12-29")) }
      it { should_not cover(date("2014-12-30")) }
      it { should_not cover(date("2015-01-01")) }
    end

    context '2015' do
      let(:year) { 2015 }

      it { should cover(date("2014-12-30")) }
      it { should cover(date("2015-01-01")) }
      it { should cover(date("2016-01-01")) }
      it { should cover(date("2016-01-04")) }

      it { should_not cover(date("2014-12-29")) }
      it { should_not cover(date("2016-01-05")) }

      it_behaves_like "ISO 8601 week based date range"
    end

    (2016..2020).each do |y|
      context y.to_s do
        let(:year) { y }
        it_behaves_like "ISO 8601 week based date range"
      end
    end
  end
end
