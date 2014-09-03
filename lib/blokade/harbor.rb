require 'singleton'

module Blokade
  class Harbor
    include Singleton

    attr_accessor :harbors

    def initialize(my_harbors={})
      self.harbors = my_harbors
    end

    def add_barrier(klass, options={}, &block)
      new_options = options.slice(:i18n, :convoy, :restrict)
      barrier = Blokade::Barrier.new(klass, new_options, &block)
      barrier.instance_eval(&block)
      existing_convoy = self.harbors[klass.constantize].try(:[], barrier.my_convoy)
      unless existing_convoy.present?
        self.harbors[klass.constantize] ||= {}
        self.harbors[klass.constantize][barrier.my_convoy] = barrier
      end

      # Add this barrier Klass to the armada directive
      begin
        if klass.constantize
          nice_klass = klass.constantize
          my_harbor = Blokade.harbor.harbors.try(:[], nice_klass)
          my_harbor_keys = my_harbor.try(:keys).present? ? my_harbor.keys : nil

          unless Blokade.armada.include?(nice_klass)
            nice_klass.send(:include, Blokade::Concerns::BarrierConcerns)
            nice_klass.send(:set_harbor_keys, my_harbor_keys)
            Blokade.armada.push(nice_klass)
          else
            # Only update the keys
            nice_klass.send(:set_harbor_keys, my_harbor_keys)
          end
        end
      rescue Exception => e
        # Do nothing
      end
    end

    def setup
      yield self
    end

  end
end
