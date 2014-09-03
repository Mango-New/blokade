module Blokade
  class Engine < ::Rails::Engine
    isolate_namespace Blokade

    config.generators do |g|
      g.hidden_namespaces << :test_unit << :erb
      g.test_framework :rspec, fixture: false, view_specs: false
      g.integration_tool :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :haml
      g.stylesheet_engine :scss
      g.assets false
      g.helper false
      g.integration_tool false
    end

    config.after_initialize do |c|
      # Role
      if defined?(Blokade.role_klass) && Blokade.role_klass.present?
        Blokade.role_klass.class_eval do
          include Blokade::Concerns::RoleConcerns
        end
      end

      # Company
      if defined?(Blokade.blokadable_klass) && Blokade.blokadable_klass.present?
        Blokade.blokadable_klass.class_eval do
          include Blokade::Concerns::BlokadeConcerns
        end
      end

      # Local Users
      if defined?(Blokade.luser_klass) && Blokade.luser_klass.present?
        Blokade.luser_klass.class_eval do
          include Blokade::Concerns::LuserConcerns
        end
      end

      # Master Users
      if defined?(Blokade.skywire_klass) && Blokade.skywire_klass.present?
        Blokade.skywire_klass.class_eval do
          include Blokade::Concerns::SkywireConcerns
        end
      end

      # Permissions
      if defined?(Blokade.permission_klass) && Blokade.permission_klass.present?
        Blokade.permission_klass.class_eval do
          include Blokade::Concerns::PermissionConcerns
        end
      end

      # Loadout the fleet
      Blokade.my_fleet.schooners.each { |k| k.loadout }
    end

  end
end
