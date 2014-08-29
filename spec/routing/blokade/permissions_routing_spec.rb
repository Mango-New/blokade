require "rails_helper"

module Blokade
  RSpec.describe PermissionsController, type: :routing do
    describe "routing" do
      routes { Blokade::Engine.routes }

      it "routes to #index" do
        expect(get: "/permissions").to route_to("blokade/permissions#index")
      end

      it "routes to #new" do
        expect(get: "/permissions/new").to route_to("blokade/permissions#new")
      end

      it "routes to #show" do
        expect(get: "/permissions/1").to route_to("blokade/permissions#show", id: "1")
      end

      it "routes to #edit" do
        expect(get: "/permissions/1/edit").to route_to("blokade/permissions#edit", id: "1")
      end

      it "routes to #create" do
        expect(post: "/permissions").to route_to("blokade/permissions#create")
      end

      it "routes to #update" do
        expect(put: "/permissions/1").to route_to("blokade/permissions#update", id: "1")
      end

    end
  end
end
