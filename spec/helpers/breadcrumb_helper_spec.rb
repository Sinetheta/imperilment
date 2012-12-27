require 'spec_helper'

describe BreadcrumbHelper do

  describe '.breadcrumb' do
    context 'given a block' do
      before(:each) do
        helper.breadcrumb { "block" }
      end
      specify { helper.breadcrumb.should == ['block'] }
    end
    context 'given content' do
      before(:each) do
        helper.breadcrumb 'content'
      end
      specify { helper.breadcrumb.should == ['content'] }
    end
  end

  describe '.render_breadcrumbs' do
    before(:each) do
      helper.stub(:breadcrumb).and_return ['second', 'first']
    end

    subject { helper.render_breadcrumbs '+' }

    specify { should == "<ul class=\"breadcrumb\"><li>first<span class=\"divider\">+</span></li><li>second</li></ul>" }
  end
end
