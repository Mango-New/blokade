class Company < ActiveRecord::Base

  acts_as_blokade as: :blokade
  blokades frontend: [:show, :edit, :update], backend: [:manage], i18n: true
  has_many :leads, dependent: :destroy

  def to_s
    name
  end

  def create_default_roles
    # Create the default schooners
    Blokade.my_fleet.schooners.each do |schooner|
      my_role = self.roles.find_or_create_by(name: schooner.role_name, key: schooner.role_name.parameterize, company: self)
      my_role.permission_ids = schooner.permission_ids
      my_role.save
    end
  end

end
