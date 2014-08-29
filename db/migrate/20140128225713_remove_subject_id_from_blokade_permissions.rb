class RemoveSubjectIdFromBlokadePermissions < ActiveRecord::Migration
  def change
    remove_column :blokade_permissions, :subject_id
  end
end
