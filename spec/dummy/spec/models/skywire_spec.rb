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
        expect(skywire.roles).to include(role)
        expect(skywire.powers).to include(power)
        expect(role.permissions).to include(permission)
        expect(role.grants).to include(grant)
        expect(role.users).to include(skywire)
        expect(luser.company).to_not be_nil

        # Perhaps this is a backend user who can add Lusers to a company
        # but does not have permission to add or edit BACKEND users (skywires)
        expect(skywire.can?(:edit, skywire)).to eq(false)
        expect(skywire.can?(:edit, luser)).to eq(true)
        expect(luser.cannot?(:edit, skywire)).to eq(true)
        expect(luser.cannot?(:edit, luser)).to eq(true)
      end

      it "should inherit permissions if specified" do
        permission = create(:blokade_permission, subject_class: "User", action: "edit", description: "Allows editing any user.", backend: true)
        role = create(:role, name: "Admin", key: "admin")
        grant = create(:blokade_grant, role: role, permission: permission)
        skywire = create(:skywire)
        luser = create(:luser, name: "Hoop Jup")
        power = create(:blokade_power, user: skywire, role: role)
        expect(skywire.roles).to include(role)
        expect(skywire.powers).to include(power)
        expect(role.permissions).to include(permission)
        expect(role.grants).to include(grant)
        expect(role.users).to include(skywire)
        expect(luser.company).to_not be_nil

        # Since they can edit the parent User model, they can edit Skywires AND Lusers.
        expect(skywire.can?(:edit, skywire)).to eq(true)
        expect(skywire.can?(:edit, luser)).to eq(true)
        expect(luser.cannot?(:edit, skywire)).to eq(true)
        expect(luser.cannot?(:edit, luser)).to eq(true)
      end
    end

    describe "concerning associations" do
      it "should have many roles through powers" do
        role = create(:role)
        user = create(:skywire)
        power = create(:blokade_power, user: user, role: role)
        expect(user.roles).to include(role)
        expect(role.users).to include(user)
      end

      it "should have many permissions through roles" do
        permission = create(:blokade_permission, backend: true)
        role = create(:role)
        grant = create(:blokade_grant, role: role, permission: permission)
        user = create(:skywire)
        power = create(:blokade_power, user: user, role: role)

        expect(permission).to be_valid
        expect(role).to be_valid
        expect(grant).to be_valid
        expect(user).to be_valid
        expect(power).to be_valid

        expect(user.permissions.backend).to include(permission)
        expect(permission.users).to include(user)
      end
    end
  end

  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:skywire)).to be_valid
    end

    it "should require a name" do
      expect(build(:skywire, name: nil)).to_not be_valid
    end

    it "should require a unique name" do
      expect(create(:skywire, name: "mark")).to be_valid
      expect(build(:skywire, name: "mark")).to_not be_valid
    end

    it "should require a unique name regardless of case" do
      expect(create(:skywire, name: "mark")).to be_valid
      expect(build(:skywire, name: "MARK")).to_not be_valid
    end
  end

  describe "concerning concerns" do
    it_behaves_like "a user concern"
  end

end
