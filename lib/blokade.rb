require "blokade/helpers/active_record"
require "blokade/configuration"
require "blokade/engine"
require "blokade/acts_as_ability"
require "blokade/concerns/barrier_concerns"
require "blokade/concerns/blokade_concerns"
require "blokade/concerns/permission_concerns"
require "blokade/concerns/role_concerns"
require "blokade/concerns/user_concerns"

require "blokade/acts_as_schooner"
require "blokade/harbor"
require 'blokade/barrier'
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
  autoload :BlokadeConcerns, "blokade/concerns/blokade_concerns"
  autoload :PermissionConcerns, "blokade/concerns/permission_concerns"
  autoload :RoleConcerns, "blokade/concerns/role_concerns"
  autoload :UserConcerns, "blokade/concerns/user_concerns"

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
