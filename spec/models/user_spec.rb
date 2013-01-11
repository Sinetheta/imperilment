require 'spec_helper'

describe User do
  AccessToken = Struct.new(:info)

  describe "abilities" do
    subject { ability }

    let(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when user is an administrator" do
      let(:user) { create :admin }

      specify { user.should have_ability(:edit, for: Game.new) }
    end
  end

  describe 'readers' do
    let(:user) { create :user }

    [:overall_score, :first, :second, :third].each do |v|
      context 'when not set' do
        specify { user.send(v).should == 0 }
      end

      context 'when set' do
        before(:each) { user.instance_variable_set("@#{v.to_s}", 10) }
        specify { user.send(v).should == 10 }
      end
    end
  end

  describe '.increment_rank' do
    let(:user) { create :user }

    subject { ->{user.increment_rank(rank)} }

    context 'when rank is 0' do
      let(:rank) { 0 }
      it { should change(user, :first).by(1) }
      it { should_not change(user, :second) }
      it { should_not change(user, :third) }
    end
    context 'when rank is 1' do
      let(:rank) { 1 }
      it { should_not change(user, :first) }
      it { should change(user, :second).by(1) }
      it { should_not change(user, :third) }
    end
    context 'when rank is 2' do
      let(:rank) { 2 }
      it { should_not change(user, :first) }
      it { should_not change(user, :second) }
      it { should change(user, :third).by(1) }
    end
    context 'when rank is anything else' do
      let(:rank) { 3 }
      it { should_not change(user, :first) }
      it { should_not change(user, :second) }
      it { should_not change(user, :third) }
    end
  end

  describe '#with_overall_score' do
    let(:game) { stub_model Game }
    let!(:user) { create :user }

    before(:each) do
      Game.stub(:locked) { [game] }
      User.any_instance.stub(:grouped_and_sorted_by_score).with(game) { {0 => [user]} }
    end

    it 'should return the users with the overall_scores' do
      User.with_overall_score.should == {0 => [user]}
    end
  end

  describe '#grouped_and_sorted_by_score' do
    let(:game) { stub_model Game }
    let!(:user) { create :user }

    before(:each) do
      game.stub(:score) { 1 }
    end

    it 'should return the users grouped and sorted by score' do
      User.grouped_and_sorted_by_score(game).should == {1 => [user]}
    end
  end

  describe '#find_for_open_id' do
    let(:result) { User.find_for_open_id(AccessToken.new({ "email" => email })) }

    context "when user exists" do
      subject { result }

      let!(:user) { create :user }
      let(:email) { user.email }

      subject { should == user }
    end

    context "when user does not exist" do
      let(:email) { 'new@user.com' }

      it 'creates a user' do
        expect { result }.to change{User.count}.by(1)
      end
    end
  end
end
