module Blokade
  module ActsAsAbility
    extend ActiveSupport::Concern

    included do
      def initialize(user)
        # This is the dynamic permission functionality
        if user.present?
          # BACK-END PERMISSIONS
          if user.respond_to?(:backend_permissions)
            if user.permissions.respond_to?(:backend)
              user.backend_permissions.backend.each do |permission|
                can permission.action.to_sym, permission.subject_class.constantize
              end
            end
          end

          # FRONT-END PERMISSIONS
          if user.respond_to?(:permissions)
            if user.permissions.respond_to?(:frontend)
              # TODO: make this work with multiple companies
              blokade_id_column = "#{Blokade.blokade_id_column}_id"

              blokade_multiple_ids_column = "#{Blokade.blokade_id_column}_ids"

              user_send_action = Blokade.one_to_one_user_associations ? blokade_id_column : blokade_multiple_ids_column

              # Unrestricted Frontend Permissions
              user.permissions.frontend.not_symbolic.unrestricted.each do |permission|
                # Check a users permissions
                if permission.subject_class.constantize.column_names.include?(blokade_id_column)
                  # Does this model have a blokadable_id column in it...
                  can permission.action.to_sym, permission.subject_class.constantize, blokade_id_column.to_sym => user.send(user_send_action)
                else
                  # ... or is it the blokadable itself?
                  can permission.action.to_sym, permission.subject_class.constantize, id: user.send(user_send_action)
                end
              end

              # Restricted Frontend Permissions
              user.permissions.frontend.not_symbolic.restricted.each do |permission|
                # Check a users permissions
                if permission.subject_class.constantize.column_names.include?(blokade_id_column)
                  # Does this model have a blokadable_id column in it...
                  can permission.action.to_sym, permission.subject_class.constantize, blokade_id_column.to_sym => user.send(user_send_action), permission.subject_class.constantize.my_frontend_restrictions.to_sym => user.id
                else
                  # ... or is it the blokadable itself?
                  can permission.action.to_sym, permission.subject_class.constantize, id: user.send(user_send_action)
                end
              end
            end
          end
        end

      end
    end

    module ClassMethods
    end
  end
end
