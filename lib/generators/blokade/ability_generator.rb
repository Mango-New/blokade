module Blokade
  module Generators
    class AbilityGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<DESC
Description:
    Copies Blokades ability model to your applications models directory.
DESC

      def copy_config_file
        template 'ability_config.rb', 'app/models/blokade_ability.rb'
      end
    end
  end
end
