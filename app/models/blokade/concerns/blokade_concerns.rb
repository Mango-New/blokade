module Blokade::Concerns::BlokadeConcerns
  extend ActiveSupport::Concern

  included do
    if Blokade.one_to_one_user_associations
      has_many :blokade_roles, dependent: :destroy, class_name: Blokade.role_klass.to_s
    end
  end

  module ClassMethods
  end

end
