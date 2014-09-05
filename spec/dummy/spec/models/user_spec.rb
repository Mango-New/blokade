require 'rails_helper'

describe User do

  # Unlimited Users
  describe "concerning unlimited users" do
    describe "concerning validations" do
      it "should have a valid factory" do
        expect(build(:unlimited_user)).to be_valid
      end

      it "should require a name" do
        expect(build(:unlimited_user, name: nil)).to_not be_valid
      end

      it "should require a unique name" do
        expect(create(:unlimited_user, name: "mark")).to be_valid
        expect(build(:unlimited_user, name: "mark")).to_not be_valid
      end

      it "should require a unique name regardless of case" do
        expect(create(:unlimited_user, name: "mark")).to be_valid
        expect(build(:unlimited_user, name: "MARK")).to_not be_valid
      end
    end

    shared_examples "a user concern" do
      describe "concering permissions and abilities" do
        it "should inherit permissions if specified" do
          permission = create(:blokade_permission, subject_class: "User", action: "edit", description: "Allows editing any user.", backend: true)
          role = create(:role, name: "Sales Manager")
          grant = create(:blokade_grant, role: role, permission: permission)
          unlimited_user = create(:unlimited_user)
          luser = create(:limited_user, name: "Hoop Jup")
          expect(unlimited_user.blokade_roles).to match_array([role])
          expect(role.permissions).to match_array([permission])
          expect(role.grants).to match_array([grant])
          expect(role.users).to match_array([unlimited_user])
          expect(luser.company).to_not be_nil

          # Since they can edit the parent User model, they can edit unlimited users AND limited users
          expect(unlimited_user.can?(:edit, unlimited_user)).to eq(true)
          expect(unlimited_user.can?(:edit, luser)).to eq(true)
          expect(luser.cannot?(:edit, unlimited_user)).to eq(true)
          expect(luser.cannot?(:edit, luser)).to eq(true)
        end
      end

      describe "concerning associations" do
        it "should have many blokade_roles through powers" do
          role = create(:role, name: "Sales Manager")
          user = create(:unlimited_user)
          expect(user.blokade_roles).to match_array([role])
          expect(role.users).to match_array([user])
        end

        it "should have many permissions through blokade_roles" do
          permission = create(:blokade_permission, backend: true)
          role = create(:role, name: "Sales Manager")
          grant = create(:blokade_grant, role: role, permission: permission)
          user = create(:unlimited_user)

          expect(permission).to be_valid
          expect(role).to be_valid
          expect(grant).to be_valid
          expect(user).to be_valid

          expect(user.backend_permissions.backend).to match_array([permission])
          expect(permission.users).to match_array([user])
        end
      end
    end

    describe "concerning concerns" do
      it_behaves_like "a user concern"
    end
  end

  # Limited Users
  describe "concerning limited users" do
    describe "concerning validations" do
      it "should have a valid factory" do
        expect(build(:limited_user)).to be_valid
      end

      it "should require a name" do
        expect(build(:limited_user, name: nil)).to_not be_valid
      end

      it "should require a unique name" do
        expect(create(:limited_user, name: "mark")).to be_valid
        expect(build(:limited_user, name: "mark")).to_not be_valid
      end

      it "should require a unique name regardless of case" do
        expect(create(:limited_user, name: "mark")).to be_valid
        expect(build(:limited_user, name: "MARK")).to_not be_valid
      end
    end

    # Limited User concerns
    shared_examples "a limited_user concern" do
      describe "concering permissions and abilities" do
        it "should restrict what they can do" do
          company1 = create(:company, name: "Planet Express")
          company2 = create(:company, name: "Moms Friendly Robot Company")
          permission = create(:blokade_permission, subject_class: "User", action: "edit", description: "Allows editing a user.")
          role = create(:role, name: "Sales Representative", company: company1)
          grant = create(:blokade_grant, role: role, permission: permission)
          luser = create(:limited_user, company: company1)
          luser2 = create(:limited_user, name: "Hoop Jup", company: company2)
          expect(luser.blokade_roles).to match_array([role])
          expect(company1.users).to_not match_array([luser2])
          expect(company1.users).to match_array([luser])
          expect(luser.company).to eq(company1)
          expect(luser.blokade_roles).to match_array([role])
          expect(company1.blokade_roles).to match_array([role])
          expect(role.permissions).to match_array([permission])
          expect(role.grants).to match_array([grant])
          expect(role.users).to match_array([luser])
          expect(luser.can?(:edit, luser)).to eq(true)
          expect(luser.cannot?(:edit, luser2)).to eq(true)
          expect(luser2.cannot?(:edit, luser)).to eq(true)
          expect(luser2.cannot?(:edit, luser2)).to eq(true)
        end
      end

      describe "concerning associations" do
        it "should belong to a company" do
          limited_user = create(:limited_user)
          expect(limited_user.company).to_not be_nil
        end

        it "should have many blokade_roles through powers" do
          company = create(:company, name: 'Phoenixfire Productions')
          role = create(:sales_representative, company: company)
          limited_user = create(:limited_user, company: company)
          power = create(:blokade_power, user: limited_user)
          expect(limited_user.blokade_roles).to match_array([role])
          expect(role.users).to match_array([limited_user])
        end

        it "should have many permissions through blokade_roles" do
          company = create(:company, name: 'Phoenixfire Productions')
          permission = create(:blokade_permission)
          role = create(:sales_representative, company: company)
          grant = create(:blokade_grant, role: role, permission: permission)
          limited_user = create(:limited_user, company: company)
          power = create(:blokade_power, user: limited_user)

          expect(company).to be_valid
          expect(permission).to be_valid
          expect(role).to be_valid
          expect(grant).to be_valid
          expect(limited_user).to be_valid
          expect(power).to be_valid

          expect(limited_user.permissions).to match_array([permission])
          expect(permission.users).to match_array([limited_user])
        end
      end
    end

    describe "concerning concerns" do
      it_behaves_like "a limited_user concern"
    end

    shared_examples "a limited_user barrier_concern" do
      it "should allow the standard frontend permissions" do
        permissions = User.frontend_permissions
        expect(permissions).to_not be_nil
        [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
          expect(permissions).to have_key(my_key)
          [:action, :subject_class, :description, :backend, :enable_restrictions].each do |sub_key|
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
        [:manage].each do |my_key|
          expect(permissions).to have_key(my_key)
          [:action, :subject_class, :description, :backend, :enable_restrictions].each do |sub_key|
            expect(permissions[my_key]).to have_key(sub_key)
          end
        end
        descriptions = ["Grants all power to create, read, update, and remove users for the company."]
        expect(permissions.values.map { |hash| hash[:action] }).to match_array(["manage"])
        expect(permissions.values.map { |hash| hash[:subject_class] }.uniq).to match_array(["User"])
        expect(permissions.values.map { |hash| hash[:description] }).to match_array(descriptions)
        expect(permissions.values.map { |hash| hash[:backend] }.uniq).to match_array([true])
        expect(permissions.values.map { |hash| hash[:enable_restrictions] }.uniq).to match_array([false])
      end
    end

    describe "concerning blokades" do
      it_behaves_like "a limited_user barrier_concern"
    end
  end

end
