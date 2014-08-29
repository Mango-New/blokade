class AddEnableRestrictionsToPermissions < ActiveRecord::Migration
  def change
    add_column :blokade_permissions, :enable_restrictions, :boolean, default: false
  end
end
