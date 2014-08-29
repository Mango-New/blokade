$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blokade/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blokade"
  s.version     = Blokade::VERSION
  s.authors     = ["Mark D Holmberg"]
  s.email       = ["mark.d.holmberg@gmail.com"]
  s.homepage    = "https://github.com/PhoenixfireDevelopment/blokade"
  s.summary     = "Adds support for CanCan permissions to be stored in a database."
  s.description = "Adds the ability for CanCan permissions to be stored in a database dynamically instead of a flat file."
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 4.1.2"
  s.add_dependency "haml-rails"
  s.add_dependency 'jquery-rails'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'bootstrap-sass', '~> 3.2.0'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency "simple_form"
  s.add_dependency 'cancan'
  s.add_dependency 'kaminari'

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "database_cleaner"

end
