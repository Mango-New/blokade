module Blokade
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc <<DESC
Description:
    Copies Blokade's configuration file to your application's initializer directory.
DESC

      def copy_config_file
        template 'blokade_config.rb', 'config/initializers/blokade.rb'
      end
    end
  end
end
