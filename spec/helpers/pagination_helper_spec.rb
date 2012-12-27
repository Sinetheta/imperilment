require 'spec_helper'

describe PaginationHelper do
  let(:records) { [] }
  before(:each) do
    records.stub(:total_pages).and_return(0)
  end

  describe '.paginate' do
    subject { helper.paginate(records) }
    specify { should_not be_nil }
  end

  describe '.paginate_info' do
    subject { helper.paginate_info(records) }
    specify { should_not be_nil }
  end

  describe '.will_paginate' do
    subject { helper.will_paginate(records) }
    specify { should be_nil }
  end
end
