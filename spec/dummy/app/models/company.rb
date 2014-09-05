class Company < ActiveRecord::Base

  has_many :leads, dependent: :destroy
  has_many :users, dependent: :destroy

  def to_s
    name
  end

  def create_default_roles
    # Create the default schooners
    Blokade.my_fleet.schooners.each do |schooner|
      my_role = self.blokade_roles.find_or_create_by(name: schooner.role_name, key: schooner.role_name.parameterize, company: self)
      my_role.permission_ids = schooner.permission_ids
      my_role.save!
    end
  end

end
