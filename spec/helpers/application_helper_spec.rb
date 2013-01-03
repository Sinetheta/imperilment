require 'spec_helper'

describe ApplicationHelper do
  describe '.app_name' do
    subject { helper.app_name }
    specify { should == 'Imperilment!' }
  end

  describe '.format_date' do
    subject { helper.format_date(date) }

    context 'when the date is nil' do
      let(:date) { nil }
      it { should be_blank }
    end

    context 'when the date is not nil' do
      let(:date) { DateTime.parse('1964-03-30') }
      it { should == '1964-03-30' }
    end
  end
end
