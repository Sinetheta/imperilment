require 'spec_helper'

def md5_hash(str)
  Digest::MD5.hexdigest(str)
end

describe ApplicationHelper do
  describe '.app_name' do
    subject { helper.app_name }
    specify { is_expected.to eq('Imperilment!') }
  end

  describe '.format_date' do
    subject { helper.format_date(date) }

    context 'when the date is nil' do
      let(:date) { nil }
      it { is_expected.to be_blank }
    end

    context 'when the date is not nil' do
      let(:date) { Date.parse('1964-03-30') }
      it { is_expected.to eq('1964-03-30') }
    end
  end

  describe '.paginate' do
    it 'should call will_paginate' do
      expect(helper).to receive(:will_paginate)
      helper.paginate(OpenStruct.new)
    end
  end

  describe 'inline_svg' do
    subject { inline_svg('imperilment-logo.svg') }

    it 'returns the file contents' do
      expect(md5_hash subject).to eq('dcd29a61e7e81998f263be03b7e1f99c')
    end

    it 'returns a safe string' do
      expect(subject.html_safe?).to be(true)
    end
  end
end
