class CreateBlokadePermissions < ActiveRecord::Migration
  def change
    create_table :blokade_permissions do |t|
      t.string :action
      t.string :subject_class
      t.integer :subject_id
      t.text :description

      t.timestamps
    end
    add_index :blokade_permissions, :action
    add_index :blokade_permissions, :subject_class
    add_index :blokade_permissions, :subject_id
  end
end
