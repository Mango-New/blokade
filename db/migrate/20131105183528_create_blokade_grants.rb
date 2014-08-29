class CreateBlokadeGrants < ActiveRecord::Migration
  def change
    create_table :blokade_grants do |t|
      t.integer :role_id
      t.integer :permission_id

      t.timestamps
    end
    add_index :blokade_grants, :role_id
    add_index :blokade_grants, :permission_id
  end
end
