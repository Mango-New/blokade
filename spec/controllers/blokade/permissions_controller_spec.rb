require 'rails_helper'

module Blokade
  RSpec.describe PermissionsController, type: :controller do
    routes { Blokade::Engine.routes }

    let(:valid_attributes) {
      attributes_for(:blokade_permission)
    }

    let(:invalid_attributes) {
      {
        action: nil,
        description: nil,
      }
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # PermissionsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all permissions as @permissions" do
        permission = Permission.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:permissions)).to eq([permission])
      end
    end

    describe "GET show" do
      it "assigns the requested permission as @permission" do
        permission = Permission.create! valid_attributes
        get :show, {id: permission.to_param}, valid_session
        expect(assigns(:permission)).to eq(permission)
      end
    end

    describe "GET new" do
      it "assigns a new permission as @permission" do
        get :new, {}, valid_session
        expect(assigns(:permission)).to be_a_new(Permission)
      end
    end

    describe "GET edit" do
      it "assigns the requested permission as @permission" do
        permission = Permission.create! valid_attributes
        get :edit, {id: permission.to_param}, valid_session
        expect(assigns(:permission)).to eq(permission)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Permission" do
          expect {
            post :create, {permission: valid_attributes}, valid_session
          }.to change(Permission, :count).by(1)
        end

        it "assigns a newly created permission as @permission" do
          post :create, {permission: valid_attributes}, valid_session
          expect(assigns(:permission)).to be_a(Permission)
          expect(assigns(:permission)).to be_persisted
        end

        it "redirects to the created permission" do
          post :create, {permission: valid_attributes}, valid_session
          expect(response).to redirect_to(Permission.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved permission as @permission" do
          post :create, {permission: invalid_attributes}, valid_session
          expect(assigns(:permission)).to be_a_new(Permission)
        end

        it "re-renders the 'new' template" do
          post :create, {permission: invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          {
            description: 'My Permission',
          }
        }

        it "updates the requested permission" do
          permission = Permission.create! valid_attributes
          put :update, {id: permission.to_param, permission: new_attributes}, valid_session
          permission.reload
          expect(permission.description).to eql("My Permission")
        end

        it "assigns the requested permission as @permission" do
          permission = Permission.create! valid_attributes
          put :update, {id: permission.to_param, permission: valid_attributes}, valid_session
          expect(assigns(:permission)).to eq(permission)
        end

        it "redirects to the permission" do
          permission = Permission.create! valid_attributes
          put :update, {id: permission.to_param, permission: valid_attributes}, valid_session
          expect(response).to redirect_to(permission)
        end
      end

      describe "with invalid params" do
        it "assigns the permission as @permission" do
          permission = Permission.create! valid_attributes
          put :update, {id: permission.to_param, permission: invalid_attributes}, valid_session
          expect(assigns(:permission)).to eq(permission)
        end

        it "re-renders the 'edit' template" do
          permission = Permission.create! valid_attributes
          put :update, {id: permission.to_param, permission: invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

  end
end
