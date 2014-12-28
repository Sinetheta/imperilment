# encoding: UTF-8
require 'spec_helper'

describe BootstrapHelper do
  describe '.icon' do
    subject { helper.icon 'hammer' }
    specify { is_expected.to eq("<i class=\"fa-hammer fa\"></i> ") }
  end

  describe '.flash_notice' do
    before(:each) do
      helper.flash['notice'] = 'test'
    end
    subject { helper.flash_notice 'notice', 'error' }
    specify { is_expected.to eq("<div class=\"alert alert-block alert-error fade in\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"alert\">×</button><h4 class=\"alert-heading\">Notice</h4><p>test</p></div>") }
  end
end
