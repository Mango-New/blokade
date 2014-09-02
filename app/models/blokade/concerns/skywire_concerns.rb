module Blokade::Concerns::SkywireConcerns
  extend ActiveSupport::Concern

  included do
    has_many :powers, dependent: :destroy, class_name: Blokade.power_klass.to_s, foreign_key: "user_id"
    has_many :roles, through: :powers
    has_many :permissions, -> { where backend: true }, through: :roles

    # This allows us to check abilities on users who are not the current user
    delegate :can?, :cannot?, to: :ability
    def ability
      @ability ||= Ability.new(self)
    end
  end

  module ClassMethods
  end

end
