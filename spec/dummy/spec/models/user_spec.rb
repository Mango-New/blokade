require 'rails_helper'

describe User do

  describe "concerning validations" do
    it "should have a valid factory" do
      build(:user).should be_valid
    end

    it "should require a name" do
      build(:user, name: nil).should_not be_valid
    end

    it "should require a unique name" do
      create(:user, name: "mark").should be_valid
      build(:user, name: "mark").should_not be_valid
    end

    it "should require a unique name regardless of case" do
      create(:user, name: "mark").should be_valid
      build(:user, name: "MARK").should_not be_valid
    end
  end

end
