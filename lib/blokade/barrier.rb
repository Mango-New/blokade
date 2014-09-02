module Blokade
  class Barrier
    attr_accessor :my_klass, :my_barriers, :my_convoy, :my_i18n

    # Create a new instance of a Barrier
    def initialize(klass, options={}, &block)
      if block_given?
        self.my_klass = klass
        self.my_barriers = []
        self.my_convoy = :default
        self.my_i18n = options.try(:[], :i18n)
      else
        raise NotImplementedError
      end
    end

    def barriers(barriers=[], options={})
      self.my_barriers = barriers
      self.my_convoy = options.try(:[], :convoy)
    end

  end
end
