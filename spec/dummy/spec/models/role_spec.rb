require 'rails_helper'

describe Role do
  shared_examples "a role concern" do
    describe "concerning ActiveRecord callbacks" do
      it "should automatically generate a key" do
        role = create(:role, name: "Sale Representative")
        expect(role.key).to_not be_nil
        expect(role.key).to eq("sale-representative")
      end
    end

    describe "concerning instance methods" do
      it "should override to_param" do
        role = create(:role, name: "Sale Representative")
        expect(role.to_param).to eq("#{role.id}-#{role.name}".parameterize)
      end
    end

    describe "concerning class methods" do
      it "should be able to find a role using get" do
        role = create(:role, name: "Sale Representative", key: "sales")
        expect(Role.get("sales")).to eq(role)
      end

      it "should have all the standard blokades" do
        expected = Role.frontend_permissions
        expect(expected.keys).to match_array([:manage, :index, :show, :new, :create, :edit, :update, :destroy])
      end
    end

    describe "concerning associations" do
      it "should belong to a company" do
        role = create(:role)
        expect(role.company).to_not be_nil
      end
    end
  end

  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:role)).to be_valid
    end
  end

  shared_examples "a role blokades_on concern" do
    it "should allow the standard frontend permissions" do
      permissions = Role.frontend_permissions
      expect(permissions).to_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        expect(permissions).to have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          expect(permissions[my_key]).to have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove roles for the company.", "Permits viewing the index of all roles for the company.", "Permits viewing a specific role for the company.", "Permits viewing the new role button and page for the company.", "Permits creating a new role for the company.", "Permits viewing the edit role button and page for the company.", "Permits updating an existing role for the company.", "Permits removing an existing role from the company."]
      expect(permissions.values.map { |hash| hash[:action] }).to match_array(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      expect(permissions.values.map { |hash| hash[:subject_class] }.uniq).to match_array(["Role"])
      expect(permissions.values.map { |hash| hash[:description] }).to match_array(descriptions)
      expect(permissions.values.map { |hash| hash[:backend] }.uniq).to match_array([false])
    end

    it "should have the standard backend permissions if the option is passed in" do
      permissions = Role.backend_permissions
      expect(permissions).to_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        expect(permissions).to have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          expect(permissions[my_key]).to have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove roles for the company.", "Permits viewing the index of all roles for the company.", "Permits viewing a specific role for the company.", "Permits viewing the new role button and page for the company.", "Permits creating a new role for the company.", "Permits viewing the edit role button and page for the company.", "Permits updating an existing role for the company.", "Permits removing an existing role from the company."]
      expect(permissions.values.map { |hash| hash[:action] }).to match_array(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      expect(permissions.values.map { |hash| hash[:subject_class] }.uniq).to match_array(["Role"])
      expect(permissions.values.map { |hash| hash[:description] }).to match_array(descriptions)
      expect(permissions.values.map { |hash| hash[:backend] }.uniq).to match_array([true])
    end
  end

  shared_examples "a schooner concern" do
    it "should have a fleet" do
      expect(Blokade.my_fleet).to_not be_nil
    end

    it "should have a Sales Representative schooner" do
      fleet = Blokade.my_fleet
      expect(fleet.schooners).to_not be_empty
      expect(fleet.find("Sales Representative")).to_not be_nil
    end

    it "should have a Sales Manager schooner" do
      fleet = Blokade.my_fleet
      expect(fleet.schooners).to_not be_empty
      expect(fleet.find("Sales Manager")).to_not be_nil
    end

    it "should have the right cargo for Sales Representative" do
      fleet = Blokade.my_fleet
      expect(fleet.schooners).to_not be_empty
      schooner = fleet.find("Sales Representative")
      expect(schooner.cargo).to match_array([{klass: Lead, blokades: [:manage], except: true, restrict: true, frontend: true}, {klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}])
    end

    it "should have the right cargo for Sales Manager" do
      fleet = Blokade.my_fleet
      expect(fleet.schooners).to_not be_empty
      schooner = fleet.find("Sales Manager")
      expect(schooner.cargo).to match_array([{klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}])
    end
  end

  describe "concerning blokades" do
    # Make sure the role blokades_on concern is properly loaded
    it_behaves_like "a role blokades_on concern"

    # Make sure the concern is properly loaded
    it_behaves_like "a role concern"

    it_behaves_like "a schooner concern"
  end
end
