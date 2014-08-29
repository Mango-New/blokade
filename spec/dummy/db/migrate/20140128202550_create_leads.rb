class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :name
      t.belongs_to :assignable, index: true
      t.belongs_to :company, index: true

      t.timestamps
    end
  end
end
