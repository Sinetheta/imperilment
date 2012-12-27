require 'spec_helper'

describe ApplicationHelper do
  describe '.app_name' do
    subject { helper.app_name }
    specify { should == 'Imperilment!' }
  end
end
