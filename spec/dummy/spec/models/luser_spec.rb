require 'rails_helper'

describe Luser do

  describe "concerning validations" do
    it "should have a valid factory" do
      build(:luser).should be_valid
    end

    it "should require a name" do
      build(:luser, name: nil).should_not be_valid
    end

    it "should require a unique name" do
      create(:luser, name: "mark").should be_valid
      build(:luser, name: "mark").should_not be_valid
    end

    it "should require a unique name regardless of case" do
      create(:luser, name: "mark").should be_valid
      build(:luser, name: "MARK").should_not be_valid
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
        company1.lusers.should include(luser)
        luser.company.should eq(company1)
        luser.roles.should include(role)
        luser.powers.should include(power)
        company1.roles.should include(role)
        role.permissions.should include(permission)
        role.grants.should include(grant)
        role.users.should include(luser)
        luser.can?(:edit, luser).should eq(true)
        luser.cannot?(:edit, luser2).should eq(true)
        luser2.cannot?(:edit, luser).should eq(true)
        luser2.cannot?(:edit, luser2).should eq(true)
      end
    end

    describe "concerning associations" do
      it "should belong to a company" do
        luser = create(:luser)
        luser.company.should_not be_nil
      end

      it "should have many roles through powers" do
        company = create(:company, name: 'Phoenixfire Productions')
        role = create(:role, company: company)
        luser = create(:luser, company: company)
        power = create(:blokade_power, user: luser, role: role)
        luser.roles.should include(role)
        role.users.should include(luser)
      end

      it "should have many permissions through roles" do
        company = create(:company, name: 'Phoenixfire Productions')
        permission = create(:blokade_permission)
        role = create(:role, company: company)
        grant = create(:blokade_grant, role: role, permission: permission)
        luser = create(:luser, company: company)
        power = create(:blokade_power, user: luser, role: role)

        company.should be_valid
        permission.should be_valid
        role.should be_valid
        grant.should be_valid
        luser.should be_valid
        power.should be_valid

        luser.permissions.should include(permission)
        permission.users.should include(luser)
      end
    end
  end

  describe "concerning concerns" do
    it_behaves_like "a luser concern"
  end

  shared_examples "a luser blokades_on concern" do
    it "should allow the standard frontend permissions" do
      permissions = User.frontend_permissions
      permissions.should_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        permissions.should have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          permissions[my_key].should have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove users for the company.", "Permits viewing the index of all users for the company.", "Permits viewing a specific user for the company.", "Permits viewing the new user button and page for the company.", "Permits creating a new user for the company.", "Permits viewing the edit user button and page for the company.", "Permits updating an existing user for the company.", "Permits removing an existing user from the company."]
      permissions.values.map { |hash| hash[:action] }.should eq(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      permissions.values.map { |hash| hash[:subject_class] }.uniq.should eq(["User"])
      permissions.values.map { |hash| hash[:description] }.should match_array(descriptions)
      permissions.values.map { |hash| hash[:backend] }.uniq.should eq([false])
      permissions.values.map { |hash| hash[:enable_restrictions] }.uniq.should eq([false])
    end

    it "should have the standard backend permissions if the option is passed in" do
      permissions = User.backend_permissions
      permissions.should_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        permissions.should have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          permissions[my_key].should have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove users for the company.", "Permits viewing the index of all users for the company.", "Permits viewing a specific user for the company.", "Permits viewing the new user button and page for the company.", "Permits creating a new user for the company.", "Permits viewing the edit user button and page for the company.", "Permits updating an existing user for the company.", "Permits removing an existing user from the company."]
      permissions.values.map { |hash| hash[:action] }.should eq(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      permissions.values.map { |hash| hash[:subject_class] }.uniq.should eq(["User"])
      permissions.values.map { |hash| hash[:description] }.should match_array(descriptions)
      permissions.values.map { |hash| hash[:backend] }.uniq.should eq([true])
    end
  end

  describe "concerning blokades" do
    it_behaves_like "a luser blokades_on concern"
  end

end
