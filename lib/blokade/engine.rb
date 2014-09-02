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
      result = []
      Blokade.armada.each do |value|
        begin
          if value.constantize
            result.push(value)
          end
        rescue Exception => e
          # Do nothing
        end
      end
      Blokade.armada = result
    end
  end
end
