module Blokade
  class Power < ActiveRecord::Base
    belongs_to :user, class_name: Blokade.user_klass.to_s, foreign_key: "user_id"
    belongs_to :role, class_name: Blokade.role_klass.to_s

    # Note: We don't allow the user to be assigned the same power twice (it wouldn't make sense!)
    # Note: We don't require the presence of user_id because if we did, then we can do `build` properly
    # Update: Technically this *could* allow a user_id of `nil`, but that's the programmer's concern.
    validates :user_id,
      uniqueness: { scope: [:role_id] }, if: Proc.new { |k| k.user_id.present? }
    validates :role_id, presence: true
  end
end
