module Blokade
  module ActsAsSchooner
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods

      def schooner(name_of_role, cargo=[])
        include Blokade::Concerns::SchoonerConcerns
        schooner(name_of_role, cargo)
      end

    end
  end
end
