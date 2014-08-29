require 'rails_helper'

module Blokade
  describe Grant do
    describe "concerning validations" do
      it "should have a valid factory" do
        expect(build(:blokade_grant)).to be_valid
      end

      it "should require a permission id" do
        expect(build(:blokade_grant, permission_id: nil)).to_not be_valid
      end

      it "should avoid duplicates" do
        role = create(:role)
        permission = create(:blokade_permission)
        grant = create(:blokade_grant, permission: permission, role: role)
        expect(grant).to be_valid
        invalid_grant = build(:blokade_grant, permission: permission, role: role)
        expect(invalid_grant).to_not be_valid
      end
    end

    describe "concerning ActiveRecord callbacks" do
      it "should be destroyed if the role is destroyed" do
        role = create(:role)
        permission = create(:blokade_permission)
        grant = create(:blokade_grant, permission: permission, role: role)
        role.destroy
        expect { grant.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should be destroyed if the permission is destroyed" do
        role = create(:role)
        permission = create(:blokade_permission)
        grant = create(:blokade_grant, permission: permission, role: role)
        permission.destroy
        expect { grant.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
