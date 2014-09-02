require 'rails_helper'

module Blokade
  RSpec.describe Blokade, type: :model do
    it "should have a permission_class method" do
      expect(Blokade.permission_klass).to_not be_nil
      expect(Blokade.permission_klass).to eq(Permission)
    end

    it "should have a grant_class method" do
      expect(Blokade.grant_klass).to_not be_nil
      expect(Blokade.grant_klass).to eq(Blokade::Grant)
    end

    it "should have a power_class method" do
      expect(Blokade.power_klass).to_not be_nil
      expect(Blokade.power_klass).to eq(Blokade::Power)
    end

    it "should have a role_class method" do
      expect(Blokade.role_klass).to_not be_nil
      expect(Blokade.role_klass).to eq(Role)
    end

    it "should have a user_class method" do
      expect(Blokade.user_klass).to_not be_nil
      expect(Blokade.user_klass).to eq(User)
    end

    it "should have a blokadable_class method" do
      expect(Blokade.blokadable_klass).to_not be_nil
      expect(Blokade.blokadable_klass).to eq(Company)
    end

    it "should have a blokadable_class method" do
      expect(Blokade.armada).to_not be_nil
      expect(Blokade.armada).to eq(["Role", "User", "Company", "Lead"])
      expect(Blokade.armada).to_not include("InvalidConstant")
    end

    it "should have a configurable default_blokades" do
      expect(Blokade.default_blokades).to_not be_nil
      expect(Blokade.default_blokades).to eq([:manage, :index, :show, :new, :create, :edit, :update, :destroy])
    end

    it "should have a symbolic_frontend_blokades" do
      expect(Blokade.symbolic_frontend_blokades).to match_array([{manage: :my_custom_engine}])
    end

    it "should have a symbolic_backend_blokades" do
      expect(Blokade.symbolic_backend_blokades).to match_array([{}])
    end
  end
end
