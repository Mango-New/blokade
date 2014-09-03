class Lead < ActiveRecord::Base

  belongs_to :assignable, class_name: "Luser"
  belongs_to :company

  validates :name, presence: true

end
