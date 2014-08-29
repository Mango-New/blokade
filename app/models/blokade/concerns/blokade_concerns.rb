module Blokade::Concerns::BlokadeConcerns
  extend ActiveSupport::Concern

  included do
    has_many :roles, dependent: :destroy
    has_many :lusers, -> { where(type: "Luser") }, class_name: "Luser", dependent: :destroy
  end

  module ClassMethods
  end

end
