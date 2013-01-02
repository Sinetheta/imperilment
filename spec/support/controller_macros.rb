module ControllerMacros

  # Controllers don't need to concern themselves with authorization
  # since we test that all seperately.
  def authorize
    before(:each) do
      @ability = Object.new.tap {|o| o.extend CanCan::Ability}
      @ability.can :manage, :all
      @controller.stub(:current_ability) { @ability }
    end
  end
end
