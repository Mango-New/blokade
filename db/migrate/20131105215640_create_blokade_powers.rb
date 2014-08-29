class CreateBlokadePowers < ActiveRecord::Migration
  def change
    create_table :blokade_powers do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
    add_index :blokade_powers, :user_id
    add_index :blokade_powers, :role_id
  end
end
