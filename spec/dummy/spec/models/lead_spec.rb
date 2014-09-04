require 'rails_helper'

describe Lead do
  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:lead)).to be_valid
    end
  end

  shared_examples "a lead barrier_concern" do
    it "should allow the standard frontend permissions" do
      permissions = Lead.frontend_permissions
      expect(permissions).to_not be_nil
      [:manage].each do |my_key|
        expect(permissions).to have_key(my_key)
        [:action, :subject_class, :description, :backend].each do |sub_key|
          expect(permissions[my_key]).to have_key(sub_key)
        end
      end
      descriptions = ["Grants all power to create, read, update, and remove leads for the company."]
      expect(permissions.values.map { |hash| hash[:action] }).to match_array(["manage"])
      expect(permissions.values.map { |hash| hash[:subject_class] }.uniq).to match_array(["Lead"])
      expect(permissions.values.map { |hash| hash[:description] }).to match_array(descriptions)
      expect(permissions.values.map { |hash| hash[:backend] }.uniq).to match_array([false])
    end

    it "should know the restrictions pertaining to it" do
      expect(Lead.my_frontend_restrictions).to eq(:assignable_id)
    end

    describe "concerning CanCan restrictions" do
      before(:each) do
        # Setup the actual roles and crap, even though it sucks
        @company = create(:company, name: "Skywire Tech")
        @permission = create(:blokade_permission, subject_class: "Lead", action: "index", description: "Allows indexing the leads", backend: false, enable_restrictions: true)
        @role = create(:sales_representative, company: @company)
        grant = create(:blokade_grant, role: @role, permission: @permission)
      end

      it "should restrict them to only seeing their own leads" do
        user1 = create(:limited_user, name: "mark", company: @company)
        user2 = create(:limited_user, name: "rob", company: @company)

        expect(user1.is_frontend_user?).to eql(true)
        expect(user2.is_frontend_user?).to eql(true)
        expect(user1.is_backend_user?).to eql(false)
        expect(user2.is_backend_user?).to eql(false)

        lead1 = create(:lead, assignable: user1, company: @company)
        lead2 = create(:lead, assignable: user2, company: @company)

        power1 = create(:blokade_power, user: user1)
        power2 = create(:blokade_power, user: user2)

        expect(Lead.accessible_by(user1.ability, :index)).to match_array([lead1])
        expect(Lead.accessible_by(user2.ability, :index)).to match_array([lead2])
      end
    end
  end

  describe "concerning blokades" do
    it_behaves_like "a lead barrier_concern"
  end

end
