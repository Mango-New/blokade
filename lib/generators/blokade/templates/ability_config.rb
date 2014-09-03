# app/models/ability.rb

class MyAbility
  include Blokade::ActsAsAbility
end

class Ability < MyAbility
  include CanCan::Ability

  def initialize(user)
    # Load the permissions from Blokade
    super

    # Let the dummies always see their dashboard.
    can :index, :dashboard
  end
end
