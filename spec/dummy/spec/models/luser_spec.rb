require 'rails_helper'

describe Luser do

  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:luser)).to be_valid
    end

    it "should require a name" do
      expect(build(:luser, name: nil)).to_not be_valid
    end

    it "should require a unique name" do
      expect(create(:luser, name: "mark")).to be_valid
      expect(build(:luser, name: "mark")).to_not be_valid
    end

    it "should require a unique name regardless of case" do
      expect(create(:luser, name: "mark")).to be_valid
      expect(build(:luser, name: "MARK")).to_not be_valid
    end
  end

  shared_examples "a luser concern" do
    describe "concering permissions and abilities" do
      it "should restrict what they can do" do
        company1 = create(:company, name: "Planet Express")
        company2 = create(:company, name: "Moms Friendly Robot Company")
        permission = create(:blokade_permission, subject_class: "User", action: "edit", description: "Allows editing a user.")
        role = create(:role, name: "Admin", key: "admin", company: company1)
        grant = create(:blokade_grant, role: role, permission: permission)
        luser = create(:luser, company: company1)
        luser2 = create(:luser, name: "Hoop Jup", company: company2)
        power = create(:blokade_power, user: luser, role: role)
        expect(company1.lusers).to include(luser)
        expect(luser.company).to eq(company1)
        expect(luser.roles).to include(role)
        expect(luser.powers).to include(power)
        expect(company1.roles).to include(role)
        expect(role.permissions).to include(permission)
        expect(role.grants).to include(grant)
        expect(role.users).to include(luser)
        expect(luser.can?(:edit, luser)).to eq(true)
        expect(luser.cannot?(:edit, luser2)).to eq(true)
        expect(luser2.cannot?(:edit, luser)).to eq(true)
        expect(luser2.cannot?(:edit, luser2)).to eq(true)
      end
    end

    describe "concerning associations" do
      it "should belong to a company" do
        luser = create(:luser)
        expect(luser.company).to_not be_nil
      end

      it "should have many roles through powers" do
        company = create(:company, name: 'Phoenixfire Productions')
        role = create(:role, company: company)
        luser = create(:luser, company: company)
        power = create(:blokade_power, user: luser, role: role)
        expect(luser.roles).to include(role)
        expect(role.users).to include(luser)
      end

      it "should have many permissions through roles" do
        company = create(:company, name: 'Phoenixfire Productions')
        permission = create(:blokade_permission)
        role = create(:role, company: company)
        grant = create(:blokade_grant, role: role, permission: permission)
        luser = create(:luser, company: company)
        power = create(:blokade_power, user: luser, role: role)

        expect(company).to be_valid
        expect(permission).to be_valid
        expect(role).to be_valid
        expect(grant).to be_valid
        expect(luser).to be_valid
        expect(power).to be_valid

        expect(luser.permissions).to include(permission)
        expect(permission.users).to include(luser)
      end
    end
  end

  describe "concerning concerns" do
    it_behaves_like "a luser concern"
  end

  shared_examples "a luser blokades_on concern" do
    it "should allow the standard frontend permissions" do
      permissions = User.frontend_permissions
      expect(permissions).to_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        expect(permissions).to have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          expect(permissions[my_key]).to have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove users for the company.", "Permits viewing the index of all users for the company.", "Permits viewing a specific user for the company.", "Permits viewing the new user button and page for the company.", "Permits creating a new user for the company.", "Permits viewing the edit user button and page for the company.", "Permits updating an existing user for the company.", "Permits removing an existing user from the company."]
      expect(permissions.values.map { |hash| hash[:action] }).to match_array(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      expect(permissions.values.map { |hash| hash[:subject_class] }.uniq).to match_array(["User"])
      expect(permissions.values.map { |hash| hash[:description] }).to match_array(descriptions)
      expect(permissions.values.map { |hash| hash[:backend] }.uniq).to match_array([false])
      expect(permissions.values.map { |hash| hash[:enable_restrictions] }.uniq).to match_array([false])
    end

    it "should have the standard backend permissions if the option is passed in" do
      permissions = User.backend_permissions
      expect(permissions).to_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        expect(permissions).to have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          expect(permissions[my_key]).to have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove users for the company.", "Permits viewing the index of all users for the company.", "Permits viewing a specific user for the company.", "Permits viewing the new user button and page for the company.", "Permits creating a new user for the company.", "Permits viewing the edit user button and page for the company.", "Permits updating an existing user for the company.", "Permits removing an existing user from the company."]
      expect(permissions.values.map { |hash| hash[:action] }).to match_array(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      expect(permissions.values.map { |hash| hash[:subject_class] }.uniq).to match_array(["User"])
      expect(permissions.values.map { |hash| hash[:description] }).to match_array(descriptions)
      expect(permissions.values.map { |hash| hash[:backend] }.uniq).to match_array([true])
    end
  end

  describe "concerning blokades" do
    it_behaves_like "a luser blokades_on concern"
  end

end
