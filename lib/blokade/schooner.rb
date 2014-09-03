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
        # Cargo is:
        # [
        #   {klass: Lead, barriers: [:manage], except: true, restrict: true, convoy: :frontend},
        #   {klass: Company, barriers: [:show, :edit, :update], only: true, restrict: false, convoy: :frontend}
        # ]
        my_permission_ids = []
        cargo.each do |c|
          klass = c.try(:[], :klass)
          barriers = c.try(:[], :barriers)
          except = c.try(:[], :except)
          only = c.try(:[], :only)
          restrict = c.try(:[], :restrict)
          convoy = c.try(:[], :convoy)

          # Find out what blokades they want
          if klass.respond_to?("my_#{convoy}_blokades".to_sym)
            if except.present?
              # desired_blokades = Blokade.default_blokades.reject { |k| barriers.include?(k) }
              desired_blokades = klass.send("my_#{convoy}_blokades".to_sym).reject { |k| barriers.include?(k) }
            elsif only.present?
              # desired_blokades = Blokade.default_blokades.select { |k| barriers.include?(k) }
              desired_blokades = klass.send("my_#{convoy}_blokades".to_sym).select { |k| barriers.include?(k) }
            end
          end

          # Get the desired permissions
          permissions = Blokade::Permission.send(convoy).where("subject_class = ? AND action IN (?) AND enable_restrictions = ?", klass, desired_blokades, restrict)
          my_permission_ids << permissions.pluck(:id)
        end
        self.permission_ids = my_permission_ids.flatten.compact
      end
    end

  end
end
