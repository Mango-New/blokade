require 'rails_helper'

describe Lead do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:lead)).to be_valid
    end
  end

  shared_examples "a lead blokades_on concern" do
    it "should allow the standard frontend permissions" do
      permissions = Lead.frontend_permissions
      expect(permissions).to_not be_nil
      [:manage, :index, :show, :new, :create, :edit, :update, :destroy].each do |my_key|
        expect(permissions).to have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          expect(permissions[my_key]).to have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove leads for the company.", "Permits viewing the index of all leads for the company.", "Permits viewing a specific lead for the company.", "Permits viewing the new lead button and page for the company.", "Permits creating a new lead for the company.", "Permits viewing the edit lead button and page for the company.", "Permits updating an existing lead for the company.", "Permits removing an existing lead from the company."]
      expect(permissions.values.map { |hash| hash[:action] }).to match_array(["manage", "index", "show", "new", "create", "edit", "update", "destroy"])
      expect(permissions.values.map { |hash| hash[:subject_class] }.uniq).to match_array(["Lead"])
      expect(permissions.values.map { |hash| hash[:description] }).to match_array(descriptions)
      expect(permissions.values.map { |hash| hash[:backend] }.uniq).to match_array([false])
    end

    it "should know the restrictions pertaining to it" do
      expect(Lead.my_restrictions).to eq(:assignable_id)
    end

    describe "concerning CanCan restrictions" do
      before(:each) do
        # Setup the actual roles and crap, even though it sucks
        @company = create(:company, name: "Skywire Tech")
        @permission = create(:blokade_permission, subject_class: "Lead", action: "index", description: "Allows indexing the leads", backend: false, enable_restrictions: true)
        @role = create(:role, name: "Sales Rep", key: "sales-rep")
        grant = create(:blokade_grant, role: @role, permission: @permission)
      end

      it "should restrict them to only seeing their own leads" do
        user1 = create(:luser, name: "mark", company: @company)
        user2 = create(:luser, name: "rob", company: @company)

        lead1 = create(:lead, assignable: user1, company: @company)
        lead2 = create(:lead, assignable: user2, company: @company)

        power1 = create(:blokade_power, user: user1, role: @role)
        power2 = create(:blokade_power, user: user2, role: @role)

        expect(Lead.accessible_by(user1.ability, :index)).to match_array([lead1])
        expect(Lead.accessible_by(user2.ability, :index)).to match_array([lead2])
      end
    end
  end

  describe "concerning blokades" do
    it_behaves_like "a lead blokades_on concern"
  end

end
