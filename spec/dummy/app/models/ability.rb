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

    if user.has_role?("sales-manager")
      can :manage, Lead, assignable_id: nil, company_id: user.company_id
    end

  end
end
