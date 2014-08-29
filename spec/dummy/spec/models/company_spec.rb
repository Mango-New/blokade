require 'rails_helper'

describe Company do
  shared_examples "a blockadable concern" do
    describe "concerning ActiveRecord callbacks" do
      it "should destroy dependent roles" do
        company = create(:company, name: 'Phoenixfire Productions')
        role = create(:role, name: 'Super Administrator', key: :superadministrator, company: company)
        company.destroy
        lambda { role.reload }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should destroy dependent lusers" do
        company = create(:company, name: 'Phoenixfire Productions')
        user = create(:luser, name: 'mark', company: company)
        company.destroy
        lambda { user.reload }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "concerning validations" do
    it "should have a valid factory" do
      build(:company).should be_valid
    end
  end

  shared_examples "a company blokades_on concern" do
    it "should allow the standard frontend permissions" do
      permissions = Company.frontend_permissions
      permissions.should_not be_nil
      [:show, :edit, :update].each do |my_key|
        permissions.should have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          permissions[my_key].should have_key(sub_key)
        end
      end
      descriptions = ["Permits viewing details about my super cool company", "Permits viewing the edit company button and page for the company.", "Permits updating an existing company for the company."]
      permissions.values.map { |hash| hash[:action] }.should eq(["show", "edit", "update"])
      permissions.values.map { |hash| hash[:subject_class] }.uniq.should eq(["Company"])
      permissions.values.map { |hash| hash[:description] }.should match_array(descriptions)
      permissions.values.map { |hash| hash[:backend] }.uniq.should eq([false])
    end

    it "should have the standard backend permissions if the option is passed in" do
      permissions = Company.backend_permissions
      permissions.should_not be_nil
      [:manage].each do |my_key|
        permissions.should have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          permissions[my_key].should have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove companies for the company."]
      permissions.values.map { |hash| hash[:action] }.should eq(["manage"])
      permissions.values.map { |hash| hash[:subject_class] }.uniq.should eq(["Company"])
      permissions.values.map { |hash| hash[:description] }.should match_array(descriptions)
      permissions.values.map { |hash| hash[:backend] }.uniq.should eq([true])
    end
  end

  describe "concerning blokades" do
    # Make sure the company blokades concern is loaded
    it_behaves_like "a company blokades_on concern"

    # Make sure the concern is properly loaded
    it_behaves_like "a blockadable concern"
  end

end
