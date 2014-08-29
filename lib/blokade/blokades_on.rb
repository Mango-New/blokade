module Blokade
  module BlokadesOn
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def blokades(options={})
        include Blokade::Concerns::BlokadesOnConcerns

        # Set the default blokades_on options
        options[:frontend] ||= Blokade.default_blokades

        # Default the backend permissions to the same as the frontend permissions
        # if they pass us the boolean option indicating that it is their intent. Otherwise
        # Set it to be equal to the backend array they passed in.
        if options.try(:[], :backend).present? && !options.try(:[], :backend).is_a?(Array)
          options[:backend] = options.try(:[], :frontend)
        else
          options[:backend] ||= []
        end

        # Setup the i18n translation for permission descriptions
        setup_i18n(options.try:[], :i18n)

        # Set my classes blokades to whatever was passed in or defaulted to
        set_blokades(frontend: options.try(:[], :frontend), backend: options.try(:[], :backend))

        # Setup restrictions
        setup_restrictions(options.try(:[], :restrict))
      end
    end
  end
end
