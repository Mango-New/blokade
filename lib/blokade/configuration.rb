module Blokade
  module Configuration
    extend ActiveSupport::Concern

    KLASS_CONSTANTS = [
      :permission_class,
      :grant_class,
      :power_class,
      :role_class,
      :user_class,
      :blokadable_class,
    ]

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      # Get our constants setup
      KLASS_CONSTANTS.each { |k| base.send(:mattr_accessor, k.to_sym) }
      base.send(:mattr_accessor, :default_blokades)
      base.send(:mattr_accessor, :one_to_one_user_associations)
      base.send(:mattr_accessor, :blokade_id_column)

      # Reset the values
      base.reset

      # Setup our Klass Constants
      base.setup_klass_constants
    end

    # Resets all the values to their defaults.
    def reset
      # Permission (Don't Override)
      self.permission_class = "Blokade::Permission"

      # Grant (Don't Override)
      self.grant_class = "Blokade::Grant"

      # Power (Don't Override)
      self.power_class = "Blokade::Power"

      # Role (Override)
      self.role_class = nil

      # User (Override)
      self.user_class = nil

      # Blokadable (Override)
      self.blokadable_class = nil

      # Default Blokades actions
      self.default_blokades = [:manage, :index, :show, :new, :create, :edit, :update, :destroy]

      # Specify if a User only belongs to a single company
      self.one_to_one_user_associations = true

      # Let them specify the exact column
      self.blokade_id_column = "blockadable"
    end

     # Allows setting all configuration options in a block
    def configure
      yield self
    end

    def setup_klass_constants
      Blokade::Configuration::KLASS_CONSTANTS.each do |klass|
        send(:define_singleton_method, "#{klass.to_s.gsub(/(_class)$/, '_klass')}".to_sym) do
          self.send(klass).try(:constantize)
        end
      end
    end

  end
end
