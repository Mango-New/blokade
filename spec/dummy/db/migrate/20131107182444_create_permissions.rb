class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :action
      t.string :subject_class
      t.integer :subject_id
      t.text :description

      t.timestamps
    end
    add_index :permissions, :action
    add_index :permissions, :subject_class
    add_index :permissions, :subject_id
  end
end
