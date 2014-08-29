module Blokade
  class Schooner
    attr_accessor :role_name, :cargo, :permission_ids

    def initialize(my_role_name, my_cargo=[])
      self.role_name = my_role_name
      self.cargo = my_cargo
    end

    # Prepare everything
    def loadout
      if cargo.present?
        my_permission_ids = []
        # Cargo is: {:klass=>Lead(no database connection), :blokades=>[:manage], :except=>true, :restrict=>true, :frontend=>true}
        cargo.each do |c|
          klass = c.try(:[], :klass)
          blokades = c.try(:[], :blokades)
          except = c.try(:[], :except)
          only = c.try(:[], :only)
          restrict = c.try(:[], :restrict)
          frontend = c.try(:[], :frontend)

          # Find out what blokades they want
          if except.present?
            if frontend
              desired_blokades = klass.my_frontend_blokades.reject { |k| blokades.include?(k) }
            else
              desired_blokades = klass.my_backend_blokades.reject { |k| blokades.include?(k) }
            end
          elsif only.present?
            if frontend
              desired_blokades = klass.my_frontend_blokades.select { |k| blokades.include?(k) }
            else
              desired_blokades = klass.my_backend_blokades.select { |k| blokades.include?(k) }
            end
          end

          # Get the desired permissions
          if frontend
            permissions = Blokade::Permission.frontend.where("subject_class = ? AND action IN (?) AND enable_restrictions = ?", klass, desired_blokades, restrict)
          else
            permissions = Blokade::Permission.backend.where("subject_class = ? AND action IN (?) AND enable_restrictions = ?", klass, desired_blokades, restrict)
          end
          my_permission_ids << permissions.pluck(:id)
        end
        self.permission_ids = my_permission_ids.flatten.compact
      end
    end

  end
end
