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

  describe '.login_path' do
    subject { helper.login_path }

    context 'Google OAuth Secret is not set' do
      it 'returns the local login path' do
        expect(subject).to eq '/users/sign_in'
      end
    end

    context 'Google OAuth Secret is set' do
      before :each do
        allow(ENV).to receive(:[]).with('GOOGLE_CLIENT_SECRET').and_return('6006l3_cl13n7_53cr37')
      end

      it 'returns the google login path' do
        expect(subject).to eq '/users/auth/google'
      end
    end
  end
end
