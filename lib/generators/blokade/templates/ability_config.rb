# app/models/blokade_ability.rb

class MyAbility
  include Blokade::ActsAsAbility
end

class BlokadeAbility < MyAbility
  include CanCan::Ability

  def initialize(user)
    # Load the permissions from Blokade
    super

    # Let the dummies always see their dashboard.
    can :index, :dashboard
  end
end
