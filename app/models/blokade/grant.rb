module Blokade
  class Grant < ActiveRecord::Base
    belongs_to :role, class_name: Blokade.role_klass.to_s
    belongs_to :permission, class_name: Blokade.permission_klass.to_s

    # Note: We don't allow the role to be assigned the
    # same permission twice (it wouldn't make sense!)
    validates :role_id,
      uniqueness: { scope: [:permission_id] }
    validates :permission_id,
      presence: true
  end
end


