module Blokade::Concerns::LuserConcerns
  extend ActiveSupport::Concern

  included do
    belongs_to Blokade.blockadable_class.model_name.singular.to_sym, class_name: Blokade.blockadable_class.to_s

    has_many :powers, dependent: :destroy, class_name: Blokade.power_class.to_s, foreign_key: "user_id"
    has_many :roles, through: :powers
    has_many :permissions, -> { where backend: false }, through: :roles

    # This allows us to check abilities on users who are not the current luser
    delegate :can?, :cannot?, to: :ability
    def ability
      @ability ||= Ability.new(self)
    end
  end

  module ClassMethods
  end

end
