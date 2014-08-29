require 'rails_helper'

module Blokade
  describe Permission do
    shared_examples "a permission concern" do
      describe "concerning validations" do
        it "should have a valid factory" do
          expect(build(:blokade_permission)).to be_valid
        end

        it "should require an action" do
          expect(build(:blokade_permission, action: nil)).to_not be_valid
        end

        it "should require a subject_class" do
          expect(build(:blokade_permission, subject_class: nil)).to_not be_valid
        end

        it "should require a description" do
          expect(build(:blokade_permission, description: nil)).to_not be_valid
        end

        it "should require backend" do
          expect(build(:blokade_permission, backend: nil)).to_not be_valid
        end
      end

      describe "concerning instance methods" do
        it "should override to_s" do
          p = create(:blokade_permission)
          expect(p.to_s).to eq("#{p.subject_class} - #{p.action} : #{p.description}")
        end

        it "should have a frontend scope" do
          p = create(:blokade_permission, backend: false)
          expected = Permission.frontend
          expect(expected).to include(p)
        end

        it "should have a backend scope" do
          p = create(:blokade_permission, backend: true)
          expected = Permission.backend
          expect(expected).to include(p)
        end

        it "should have a not_symbolic scope" do
          symbolic = create(:blokade_permission, subject_class: ":blokade")
          not_symbolic = create(:blokade_permission, subject_class: "Permission")
          expected = Permission.not_symbolic
          expect(expected).to include(not_symbolic)
          expect(expected).to_not include(symbolic)
        end

        it "should have a symbolic scope" do
          symbolic = create(:blokade_permission, subject_class: ":blokade")
          not_symbolic = create(:blokade_permission, subject_class: "Permission")
          expected = Permission.symbolic
          expect(expected).to include(symbolic)
          expect(expected).to_not include(not_symbolic)
        end

        it "should have a restricted scope" do
          restricted = create(:blokade_permission, enable_restrictions: true)
          not_restricted = create(:blokade_permission, enable_restrictions: false)
          expected = Permission.restricted
          expect(expected).to include(restricted)
          expect(expected).to_not include(not_restricted)
        end

        it "should have an unrestricted scope" do
          unrestricted = create(:blokade_permission, enable_restrictions: false)
          restricted = create(:blokade_permission, enable_restrictions: true)
          expected = Permission.unrestricted
          expect(expected).to include(unrestricted)
          expect(expected).to_not include(restricted)
        end
      end

      describe "concerning associations" do
        it "should have many users and roles" do
          permission = create(:blokade_permission)
          company = create(:company)
          user = create(:luser, company: company)
          role = create(:role, company: company, name: "Administrator")
          grant = create(:blokade_grant, permission: permission, role: role)
          expect(grant.role).to eq(role)
          expect(grant.permission).to eq(permission)
          power = create(:blokade_power, user: user, role: role)
          expect(power.role).to eq(role)
          expect(power.user).to eq(user)
          expect(role.users).to include(user)
          expect(user.roles).to include(role)
          expect(permission.roles).to include(role)
          expect(role.permissions).to include(permission)
          expect(permission.users).to include(user)
          expect(user.permissions).to include(permission)
        end
      end

      describe "concerning class methods" do
        it "should have a frontend_permissions method" do
          expect(Permission.frontend_permissions).to_not be_nil
          current = Permission.frontend_permissions
          expect(current.keys).to match_array([:role, :user, :company, :lead])
          expect(current[:role]).to match_array(Role.frontend_permissions)
          expect(current[:user]).to match_array(User.frontend_permissions)
          expect(current[:company]).to match_array(Company.frontend_permissions)
        end

        it "should have a backend_permissions method" do
          expect(Permission.backend_permissions).to_not be_nil
          current = Permission.backend_permissions
          expect(current.keys).to match_array([:role, :user, :company, :lead])
          expect(current[:role]).to match_array(Role.backend_permissions)
          expect(current[:user]).to match_array(User.backend_permissions)
          expect(current[:company]).to match_array(Company.backend_permissions)
        end
      end
    end

    describe "concerning validations" do
      it "should have a valid factory" do
        expect(build(:blokade_permission)).to be_valid
      end
    end

    # Make sure the concern is properly loaded
    it_behaves_like "a permission concern"
  end
end
