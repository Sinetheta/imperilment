require 'spec_helper'

def first_element html
  Nokogiri::HTML::fragment(html).children.first
end

describe Bootstrap::LabelHelper do
  describe 'default label' do
    subject { first_element bs_label 'Foo' }

    it 'creates a span' do
      expect(subject.name).to eq 'span'
    end
    it 'contains the content' do
      expect(subject.text).to eq 'Foo'
    end
    it 'has a label class' do
      expect(subject['class']).to include 'label'
    end
    it 'has a default label class' do
      expect(subject['class']).to include 'label-default'
    end
  end

  describe 'styled label' do
    subject { first_element bs_label 'Bar', style }

    [:success, 'success'].each do |style|
      let(:style) { style }

      it "acepts a #{style.class} as a style" do
        expect(subject['class']).to include 'label-success'
      end
    end
  end

  describe 'custom options' do
    subject { first_element bs_label('Cats', :default, options) }

    context 'when a class' do
      let(:options) { { class: 'bonus' } }

      it 'adds to the class list' do
        expect(subject['class']).to include 'bonus'
      end
    end
    context 'when a class list' do
      let(:options) { { class: ['multiple', 'classes'] } }

      it 'adds them all to the class list' do
        expect(subject['class']).to include 'multiple', 'classes'
      end
    end
    context 'when not a class' do
      let(:options) { { title: 'A title!' } }

      it 'passes along the option' do
        expect(subject['title']).to eq 'A title!'
      end
    end
  end
end
