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
