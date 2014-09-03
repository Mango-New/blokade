module Blokade
  module ActsAsAbility
    extend ActiveSupport::Concern

    included do
      def initialize(user)
        # This is the dynamic permission functionality

        # BACK-END PERMISSIONS
        user.permissions.backend.each do |permission|
          can permission.action.to_sym, permission.subject_class.constantize
        end

        # FRONT-END PERMISSIONS
        blokade_id_column = "#{Blokade.blokadable_klass.model_name.element}_id"

        # Unrestricted Frontend Permissions
        user.permissions.frontend.not_symbolic.unrestricted.each do |permission|
          # Check a users permissions
          if permission.subject_class.constantize.column_names.include?(blokade_id_column)
            # Does this model have a blokadable_id column in it...
            can permission.action.to_sym, permission.subject_class.constantize, blokade_id_column.to_sym => user.send(blokade_id_column)
          else
            # ... or is it the blokadable itself?
            can permission.action.to_sym, permission.subject_class.constantize, :id => user.send(blokade_id_column)
          end
        end

        # Restricted Frontend Permissions
        user.permissions.frontend.not_symbolic.restricted.each do |permission|
          # Check a users permissions
          if permission.subject_class.constantize.column_names.include?(blokade_id_column)
            # Does this model have a blokadable_id column in it...
            can permission.action.to_sym, permission.subject_class.constantize, blokade_id_column.to_sym => user.send(blokade_id_column), permission.subject_class.constantize.my_frontend_restrictions.to_sym => user.id
          else
            # ... or is it the blokadable itself?
            can permission.action.to_sym, permission.subject_class.constantize, :id => user.send(blokade_id_column)#, permission.subject_class.constantize.my_restrictions.to_sym => user.id
          end
        end

      end
    end

    module ClassMethods
    end
  end
end
