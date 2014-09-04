module Blokade::Concerns::BlokadeConcerns
  extend ActiveSupport::Concern

  included do
    if Blokade.one_to_one_user_associations
      has_many :roles, dependent: :destroy
    end
  end

  module ClassMethods
  end

end
