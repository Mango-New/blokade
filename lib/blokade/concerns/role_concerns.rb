module Blokade
  module Concerns
    module RoleConcerns
      extend ActiveSupport::Concern

      included do
        belongs_to Blokade.blokadable_klass.model_name.singular.to_sym, class_name: Blokade.blokadable_klass.to_s

        has_many :grants, dependent: :destroy, class_name: Blokade.grant_klass.to_s
        has_many :permissions, through: :grants
        has_many :powers, dependent: :destroy, class_name: Blokade.power_klass.to_s
        has_many :users, through: :powers, class_name: Blokade.user_klass.to_s

        before_validation :generate_key


        def to_param
          "#{id}-#{name}".parameterize
        end

        def self.has_key_column?
          Blokade.role_klass.column_names.include?("key")
        end

        private

        def generate_key
          if Role.has_key_column?
            self.key = name.parameterize unless key.present?
          end
        end
      end

      module ClassMethods
        def get(key)
          where(key: key).first
        end
      end
    end
  end
end
