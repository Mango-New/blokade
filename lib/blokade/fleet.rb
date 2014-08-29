module Blokade
  class Fleet
    attr_accessor :schooners

    def initialize
      self.schooners ||= []
    end

    def include?(thing)
      schooners.map(&:role_name).include?(thing)
    end

    def find(name_of_schooner)
      schooners.select { |k| (k.role_name == name_of_schooner) }.first
    end

    def dock(schooner)
      # Add
      self.schooners.push(schooner) unless schooners.include?(schooner)
    end

    def deploy(schooner)
      # Remove
      self.schooners.delete_at(schooners.index(schooner)) if schooners.include?(schooner)
    end
  end
end
