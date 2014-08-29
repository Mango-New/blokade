module Blokade::Concerns::SchoonerConcerns
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def schooner(name_of_role, cargo=[])
      unless Blokade.my_fleet.include?(name_of_role)
        # Don't add this schooner twice!
        schooner = Blokade::Schooner.new(name_of_role, cargo)
        Blokade.my_fleet.dock(schooner)
        schooner.loadout
      end
    end
  end
end
