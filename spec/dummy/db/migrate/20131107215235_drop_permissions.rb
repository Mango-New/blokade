class DropPermissions < ActiveRecord::Migration
  def change
    drop_table :permissions
  end
end
