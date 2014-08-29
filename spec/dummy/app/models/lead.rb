class Lead < ActiveRecord::Base

  blokades restrict: :assignable_id

  belongs_to :assignable, class_name: "Luser"
  belongs_to :company

  validates :name, presence: true

end
