module Blokade::Concerns::BlokadeConcerns
  extend ActiveSupport::Concern

  included do
    has_many :roles, dependent: :destroy
  end

  module ClassMethods
  end

end
