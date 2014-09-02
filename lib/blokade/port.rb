require 'singleton'

module Blokade
  class Port
    include Singleton

    attr_accessor :barriers

    def initialize(my_barriers=[])
      self.barriers = my_barriers
    end

    def add_barrier(klass, options={}, &block)
      new_options = options.slice(:i18n, :convoy)
      barrier = Blokade::Barrier.new(klass, new_options, &block)
      barrier.instance_eval(&block)
      self.barriers << barrier unless self.barriers.include?(barrier)
    end

    def setup
      yield self
    end

  end
end
