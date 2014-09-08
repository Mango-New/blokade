module Blokade
  module Concerns
    module PermissionConcerns
      extend ActiveSupport::Concern

      included do
        has_many :grants, dependent: :destroy, class_name: Blokade.grant_klass.to_s
        has_many :blokade_roles, through: :grants, class_name: Blokade.role_klass.to_s, source: :role
        has_many :users, through: :blokade_roles

        validates :action, presence: true
        validates :subject_class, presence: true
        validates :description, presence: true
        validates :backend,
          inclusion: { in: [true, false] }

        scope :ordered, -> { order("#{Blokade.permission_klass.model_name.plural}.subject_class ASC") }
        scope :with_subject_class, lambda { |subject_class| where(subject_class: subject_class) }
        scope :frontend, -> { where(backend: false) }
        scope :backend, -> { where(backend: true) }
        scope :symbolic, -> { where("#{Blokade.permission_klass.model_name.plural}.subject_class LIKE (?)", ":%") }
        scope :not_symbolic, -> { where("#{Blokade.permission_klass.model_name.plural}.subject_class NOT LIKE (?)", ":%") }
        scope :restricted, -> { where(enable_restrictions: true) }
        scope :unrestricted, -> { where(enable_restrictions: false) }

        def to_s
          "#{subject_class} - #{action} : #{description}"
        end
      end

      module ClassMethods
        def frontend_permissions
          # Gather the fleet!
          result = {}
          Blokade.armada.each do |my_armada|
            if my_armada.respond_to?(:frontend_permissions)
              # Make sure they didn't pass us a class which didn't invoke a call to `blokades`
              singular = my_armada.model_name.singular
              result[singular.to_sym] = my_armada.frontend_permissions
            end
          end
          result
        end

        def backend_permissions
          # Gather the fleet!
          result = {}
          Blokade.armada.each do |my_armada|
            if my_armada.respond_to?(:backend_permissions)
              singular = my_armada.model_name.singular
              result[singular.to_sym] = my_armada.backend_permissions
            end
          end
          result
        end
      end
    end
  end
end
