class User < ActiveRecord::Base

  blokades backend: true

  validates :name,
    uniqueness: { case_sensitive: false },
    presence: true

end
