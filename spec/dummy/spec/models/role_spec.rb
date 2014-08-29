require 'rails_helper'

describe Role do
  shared_examples "a role concern" do
    describe "concerning ActiveRecord callbacks" do
      it "should automatically generate a key" do
        role = create(:role, name: "Sale Representative")
        role.key.should_not be_nil
        role.key.should eq("sale-representative")
      end
    end

    describe "concerning instance methods" do
      it "should override to_param" do
        role = create(:role, name: "Sale Representative")
        role.to_param.should eq("#{role.id}-#{role.name}".parameterize)
      end
    end

    describe "concerning class methods" do
      it "should be able to find a role using get" do
        role = create(:role, name: "Sale Representative", key: "sales")
        Role.get("sales").should eq(role)
      end

      it "should have all the standard blokades" do
        expected = Role.frontend_permissions
        expected.keys.should eq([:manage, :index, :show, :new, :create, :edit, :update, :destroy])
      end
    end

    describe "concerning associations" do
      it "should belong to a company" do
        role = create(:role)
        role.company.should_not be_nil
      end
    end
  end

  describe "concerning validations" do
    it "should have a valid factory" do
      build(:role).should be_valid
    end
  end

  shared_examples "a role blokades_on concern" do
    it "should allow the standard frontend permissions" do
      permissions = Role.frontend_permissions
      permissions.should_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        permissions.should have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          permissions[my_key].should have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove roles for the company.", "Permits viewing the index of all roles for the company.", "Permits viewing a specific role for the company.", "Permits viewing the new role button and page for the company.", "Permits creating a new role for the company.", "Permits viewing the edit role button and page for the company.", "Permits updating an existing role for the company.", "Permits removing an existing role from the company."]
      permissions.values.map { |hash| hash[:action] }.should eq(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      permissions.values.map { |hash| hash[:subject_class] }.uniq.should eq(["Role"])
      permissions.values.map { |hash| hash[:description] }.should match_array(descriptions)
      permissions.values.map { |hash| hash[:backend] }.uniq.should eq([false])
    end

    it "should have the standard backend permissions if the option is passed in" do
      permissions = Role.backend_permissions
      permissions.should_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        permissions.should have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          permissions[my_key].should have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove roles for the company.", "Permits viewing the index of all roles for the company.", "Permits viewing a specific role for the company.", "Permits viewing the new role button and page for the company.", "Permits creating a new role for the company.", "Permits viewing the edit role button and page for the company.", "Permits updating an existing role for the company.", "Permits removing an existing role from the company."]
      permissions.values.map { |hash| hash[:action] }.should eq(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      permissions.values.map { |hash| hash[:subject_class] }.uniq.should eq(["Role"])
      permissions.values.map { |hash| hash[:description] }.should match_array(descriptions)
      permissions.values.map { |hash| hash[:backend] }.uniq.should eq([true])
    end
  end

  shared_examples "a schooner concern" do
    it "should have a fleet" do
      Blokade.my_fleet.should_not be_nil
    end

    it "should have a Sales Representative schooner" do
      fleet = Blokade.my_fleet
      fleet.schooners.should_not be_empty
      fleet.find("Sales Representative").should_not be_nil
    end

    it "should have a Sales Manager schooner" do
      fleet = Blokade.my_fleet
      fleet.schooners.should_not be_empty
      fleet.find("Sales Manager").should_not be_nil
    end

    it "should have the right cargo for Sales Representative" do
      fleet = Blokade.my_fleet
      fleet.schooners.should_not be_empty
      schooner = fleet.find("Sales Representative")
      schooner.cargo.should match_array([{klass: Lead, blokades: [:manage], except: true, restrict: true, frontend: true}, {klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}])
    end

    it "should have the right cargo for Sales Manager" do
      fleet = Blokade.my_fleet
      fleet.schooners.should_not be_empty
      schooner = fleet.find("Sales Manager")
      schooner.cargo.should match_array([{klass: Company, blokades: [:show, :edit, :update], only: true, restrict: false, frontend: true}])
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
