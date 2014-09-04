class User < ActiveRecord::Base

  has_many :leads, foreign_key: "assignable_id"

  validates :name,
    uniqueness: { case_sensitive: false },
    presence: true


  def has_role?(role_key)
    roles.get(role_key).present?
  end

  def is_frontend_user?
    has_role?("sales-representative")
  end

  def is_backend_user?
    has_role?("sales-manager")
  end

end
