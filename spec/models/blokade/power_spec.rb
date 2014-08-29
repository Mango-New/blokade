require 'rails_helper'

module Blokade
  describe Power do
    describe "concerning validations" do
      it "should have a valid factory" do
        expect(build(:blokade_power)).to be_valid
      end

      it "should require a role id" do
        expect(build(:blokade_power, role_id: nil)).to_not be_valid
      end

      it "should avoid duplicates" do
        role = create(:role)
        user = create(:luser)
        power = create(:blokade_power, user: user, role: role)
        expect(power).to be_valid
        invalid_power = build(:blokade_power, user: user, role: role)
        expect(invalid_power).to_not be_valid
      end
    end

    describe "concerning ActiveRecord callbacks" do
      it "should be destroyed if the role is destroyed" do
        role = create(:role)
        user = create(:luser)
        power = create(:blokade_power, user: user, role: role)
        role.destroy
        expect { power.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should be destroyed if the user is destroyed" do
        role = create(:role)
        user = create(:luser)
        power = create(:blokade_power, user: user, role: role)
        user.destroy
        expect { power.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
