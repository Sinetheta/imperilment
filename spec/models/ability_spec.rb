require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  let(:user) { build_stubbed :user }
  let(:ability) { Ability.new(user) }

  subject { ability }

  context 'when user has admin privileges' do
    before(:each) { user.stub(:has_role?).with(:admin) { true } }
    it { should be_able_to :manage, :all }
  end

  context 'when user is not an administrator' do
    it { should_not be_able_to :manage, :all }
  end
end
