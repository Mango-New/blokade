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
  # Permission (Don't Override)
  mattr_accessor :permission_class
  @@permission_class = "Blokade::Permission"

  # Grant (Don't Override)
  mattr_accessor :grant_class
  @@grant_class = "Blokade::Grant"

  # Power (Don't Override)
  mattr_accessor :power_class
  @@power_class = "Blokade::Power"

  # Role (Override)
  mattr_accessor :role_class
  @@role_class = "Blokade::Role"

  # User (Override)
  mattr_accessor :user_class
  @@user_class = "Blokade::User"

  # Blockadable (Override)
  mattr_accessor :blockadable_class
  @@blockadable_class = "Blokade::Blockadable"

  # Armada (Absolutely Override)
  mattr_accessor :armada
  @@armada = nil

  # Default Blokades actions
  mattr_accessor :default_blokades
  @@default_blokades = [:manage, :index, :show, :new, :create, :edit, :update, :destroy]

  mattr_accessor :symbolic_frontend_blokades
  @@symbolic_frontend_blokades = [{}]

  mattr_accessor :symbolic_backend_blokades
  @@symbolic_backend_blokades = [{}]

  mattr_accessor :my_fleet
  @@my_fleet = Blokade::Fleet.new

  def self.permission_class
    @@permission_class.constantize
  end

  def self.grant_class
    @@grant_class.constantize
  end

  def self.power_class
    @@power_class.constantize
  end

  def self.role_class
    @@role_class.constantize
  end

  def self.user_class
    @@user_class.constantize
  end

  def self.blockadable_class
    @@blockadable_class.constantize
  end

  def self.setup
    yield self
  end

  ActiveRecord::Base.send :include, Blokade::ActsAsBlokade
  ActiveRecord::Base.send :include, Blokade::BlokadesOn
  ActiveRecord::Base.send :include, Blokade::ActsAsSchooner

end
