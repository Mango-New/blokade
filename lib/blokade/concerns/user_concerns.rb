module Blokade
  module Concerns
    module UserConcerns
      extend ActiveSupport::Concern

      included do
        if Blokade.one_to_one_user_associations
          belongs_to Blokade.blokadable_klass.model_name.singular.to_sym, class_name: Blokade.blokadable_klass.to_s
        end

        has_many :powers, dependent: :destroy, class_name: Blokade.power_klass.to_s, foreign_key: "user_id"
        has_many :blokade_roles, through: :powers, class_name: Blokade.role_klass.to_s, source: :role

        if Proc.new { |k| k.is_frontend_user? }
          has_many :permissions, -> { where backend: false }, through: :blokade_roles
        end

        if Proc.new { |k| k.is_backend_user? }
          has_many :backend_permissions, -> { where backend: true }, through: :blokade_roles, source: :permissions
        end

        # This allows us to check abilities on users who are not the current one
        delegate :can?, :cannot?, to: :ability
        def ability
          @ability ||= Ability.new(self)
        end

        def is_frontend_user?
          true
        end

        def is_backend_user?
          false
        end
      end

      module ClassMethods
      end

    end
  end
end
