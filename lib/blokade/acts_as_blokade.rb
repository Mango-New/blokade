module Blokade
  module ActsAsBlokade
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_blokade(options={})
        as_option = options.try(:[], :as)
        case as_option
        when :blokade
          include Blokade::Concerns::BlokadeConcerns
        when :role
          include Blokade::Concerns::RoleConcerns
        when :luser
          include Blokade::Concerns::LuserConcerns
        when :skywire
          include Blokade::Concerns::SkywireConcerns
        when :permission
          include Blokade::Concerns::PermissionConcerns
        end
      end
    end
  end
end
