require "blokade/configuration"
require "blokade/engine"
require "blokade/acts_as_blokade"
require "blokade/acts_as_ability"
require "blokade/blokades_on"
require "blokade/acts_as_schooner"
require "blokade/fleet"
require "blokade/schooner"
require 'haml'
require "blokade/simple_form"
require 'jquery-rails'
require 'coffee-rails'
require 'cancan'
require 'bootstrap-sass'
require 'kaminari'

module Blokade
  extend Configuration

  # Armada (Absolutely Override)
  mattr_accessor :armada
  @@armada = nil

  mattr_accessor :symbolic_frontend_blokades
  @@symbolic_frontend_blokades = [{}]

  mattr_accessor :symbolic_backend_blokades
  @@symbolic_backend_blokades = [{}]

  mattr_accessor :my_fleet
  @@my_fleet = Blokade::Fleet.new

  # Include our stuff
  ActiveRecord::Base.send :include, Blokade::ActsAsBlokade
  ActiveRecord::Base.send :include, Blokade::BlokadesOn
  ActiveRecord::Base.send :include, Blokade::ActsAsSchooner

end
