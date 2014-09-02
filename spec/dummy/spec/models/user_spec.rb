require 'rails_helper'

describe User do

  describe "concerning validations" do
    it "should have a valid factory" do
      expect(build(:user)).to be_valid
    end

    it "should require a name" do
      expect(build(:user, name: nil)).to_not be_valid
    end

    it "should require a unique name" do
      expect(create(:user, name: "mark")).to be_valid
      expect(build(:user, name: "mark")).to_not be_valid
    end

    it "should require a unique name regardless of case" do
      expect(create(:user, name: "mark")).to be_valid
      expect(build(:user, name: "MARK")).to_not be_valid
    end
  end

end
