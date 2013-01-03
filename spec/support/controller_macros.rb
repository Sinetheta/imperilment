module ControllerMacros
  def login
    before(:each) do
      unless user.nil?
        mapping_symbol = user.has_role?(:admin) ? :admin : :user
        @request.env["devise.mapping"] = Devise.mappings[mapping_symbol]
        @controller.stub(:current_user).and_return(user)
        sign_in mapping_symbol, user
      end
    end
  end

  def logout
    before(:each) do
      unless user.nil?
        @controller.stub(:current_user).and_return(nil)
        sign_out user
      end
    end
  end

  # Controllers don't need to concern themselves with authorization
  # since we test that all seperately.
  def authorize
    before(:each) do
      @ability = Object.new.tap {|o| o.extend CanCan::Ability}
      @ability.can :manage, :all
      @controller.stub(:current_ability) { @ability }
    end
  end

  def authorize_and_login
    authorize
    login
  end
end
