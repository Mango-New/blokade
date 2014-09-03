class Luser < User

  has_many :leads, foreign_key: "assignable_id"

end
