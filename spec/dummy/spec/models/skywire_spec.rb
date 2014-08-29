require 'rails_helper'

describe User do

  shared_examples "a user concern" do
    describe "concering permissions and abilities" do
      it "should restrict them to inherited classes" do
        permission = create(:blokade_permission, subject_class: "Luser", action: "edit", description: "Allows editing a local user.", backend: true)
        role = create(:role, name: "Admin", key: "admin")
        grant = create(:blokade_grant, role: role, permission: permission)
        skywire = create(:skywire)
        luser = create(:luser, name: "Hoop Jup")
        power = create(:blokade_power, user: skywire, role: role)
        skywire.roles.should include(role)
        skywire.powers.should include(power)
        role.permissions.should include(permission)
        role.grants.should include(grant)
        role.users.should include(skywire)
        luser.company.should_not be_nil

        # Perhaps this is a backend user who can add Lusers to a company
        # but does not have permission to add or edit BACKEND users (skywires)
        skywire.can?(:edit, skywire).should eq(false)
        skywire.can?(:edit, luser).should eq(true)
        luser.cannot?(:edit, skywire).should eq(true)
        luser.cannot?(:edit, luser).should eq(true)
      end

      it "should inherit permissions if specified" do
        permission = create(:blokade_permission, subject_class: "User", action: "edit", description: "Allows editing any user.", backend: true)
        role = create(:role, name: "Admin", key: "admin")
        grant = create(:blokade_grant, role: role, permission: permission)
        skywire = create(:skywire)
        luser = create(:luser, name: "Hoop Jup")
        power = create(:blokade_power, user: skywire, role: role)
        skywire.roles.should include(role)
        skywire.powers.should include(power)
        role.permissions.should include(permission)
        role.grants.should include(grant)
        role.users.should include(skywire)
        luser.company.should_not be_nil

        # Since they can edit the parent User model, they can edit Skywires AND Lusers.
        skywire.can?(:edit, skywire).should eq(true)
        skywire.can?(:edit, luser).should eq(true)
        luser.cannot?(:edit, skywire).should eq(true)
        luser.cannot?(:edit, luser).should eq(true)
      end
    end

    describe "concerning associations" do
      it "should have many roles through powers" do
        role = create(:role)
        user = create(:skywire)
        power = create(:blokade_power, user: user, role: role)
        user.roles.should include(role)
        role.users.should include(user)
      end

      it "should have many permissions through roles" do
        permission = create(:blokade_permission, backend: true)
        role = create(:role)
        grant = create(:blokade_grant, role: role, permission: permission)
        user = create(:skywire)
        power = create(:blokade_power, user: user, role: role)

        permission.should be_valid
        role.should be_valid
        grant.should be_valid
        user.should be_valid
        power.should be_valid

        user.permissions.backend.should include(permission)
        permission.users.should include(user)
      end
    end
  end

  describe "concerning validations" do
    it "should have a valid factory" do
      build(:skywire).should be_valid
    end

    it "should require a name" do
      build(:skywire, name: nil).should_not be_valid
    end

    it "should require a unique name" do
      create(:skywire, name: "mark").should be_valid
      build(:skywire, name: "mark").should_not be_valid
    end

    it "should require a unique name regardless of case" do
      create(:skywire, name: "mark").should be_valid
      build(:skywire, name: "MARK").should_not be_valid
    end
  end

  describe "concerning concerns" do
    it_behaves_like "a user concern"
  end

end
