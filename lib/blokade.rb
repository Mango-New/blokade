require "blokade/configuration"
require "blokade/engine"
require "blokade/acts_as_ability"
require "blokade/concerns/barrier_concerns"
require "blokade/harbor"
require 'blokade/barrier'
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

  autoload :BarrierConcerns, "blokade/concerns/barrier_concerns"

  # Singleton that holds everything
  mattr_accessor :harbor

  def self.harbor
    Harbor.instance
  end

  # Armada (Absolutely Override)
  mattr_accessor :armada
  @@armada = []

  mattr_accessor :symbolic_frontend_blokades
  @@symbolic_frontend_blokades = [{}]

  mattr_accessor :symbolic_backend_blokades
  @@symbolic_backend_blokades = [{}]

  mattr_accessor :my_fleet
  @@my_fleet = Blokade::Fleet.new

  ActiveRecord::Base.send :include, Blokade::ActsAsSchooner

end
