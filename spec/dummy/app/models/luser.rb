class Luser < User

  acts_as_blokade as: :luser
  has_many :leads, foreign_key: "assignable_id"

end
