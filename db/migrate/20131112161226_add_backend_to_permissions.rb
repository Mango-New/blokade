class AddBackendToPermissions < ActiveRecord::Migration
  def change
    add_column :blokade_permissions, :backend, :boolean, default: false
    add_index :blokade_permissions, :backend
  end
end
