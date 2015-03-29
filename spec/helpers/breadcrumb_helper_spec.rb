require 'spec_helper'

describe BreadcrumbHelper do
  describe '.breadcrumb' do
    context 'given a block' do
      before(:each) do
        helper.breadcrumb { "block" }
      end
      specify { expect(helper.breadcrumb).to eq(['block']) }
    end
    context 'given content' do
      before(:each) do
        helper.breadcrumb 'content'
      end
      specify { expect(helper.breadcrumb).to eq(['content']) }
    end
  end

  describe '.render_breadcrumbs' do
    before(:each) do
      allow(helper).to receive(:breadcrumb).and_return %w(second first)
    end

    subject { helper.render_breadcrumbs '+' }

    specify { is_expected.to eq("<ul class=\"breadcrumb\"><li>first<span class=\"divider\">+</span></li><li>second</li></ul>") }
  end
end
