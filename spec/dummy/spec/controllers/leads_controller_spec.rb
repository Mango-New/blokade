require 'rails_helper'

RSpec.describe LeadsController, type: :controller do

  let(:company) { create(:company, name: 'Planet Express') }
  let(:limited_user) { create(:limited_user, name: "John Doe", company: company) }

  before(:each) do
    stub_cancan_authorize([Lead])
    allow(controller).to receive(:current_user).and_return(limited_user)
    allow(controller).to receive(:current_company).and_return(company)
    expect(company.users).to match_array([limited_user])
  end

  let(:valid_attributes) { attributes_for(:lead).merge(company_id: company.id) }

  let(:invalid_attributes) {
    {
      name: nil,
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LeadsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all leads as @leads" do
      lead = Lead.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:leads)).to eq([lead])
    end
  end

  describe "GET show" do
    it "assigns the requested lead as @lead" do
      lead = Lead.create! valid_attributes
      get :show, {id: lead.to_param}, valid_session
      expect(assigns(:lead)).to eq(lead)
    end
  end

  describe "GET new" do
    it "assigns a new lead as @lead" do
      get :new, {}, valid_session
      expect(assigns(:lead)).to be_a_new(Lead)
    end
  end

  describe "GET edit" do
    it "assigns the requested lead as @lead" do
      lead = Lead.create! valid_attributes
      get :edit, {id: lead.to_param}, valid_session
      expect(assigns(:lead)).to eq(lead)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Lead" do
        expect {
          post :create, {lead: valid_attributes}, valid_session
        }.to change(Lead, :count).by(1)
      end

      it "assigns a newly created lead as @lead" do
        post :create, {lead: valid_attributes}, valid_session
        expect(assigns(:lead)).to be_a(Lead)
        expect(assigns(:lead)).to be_persisted
      end

      it "redirects to the created lead" do
        post :create, {lead: valid_attributes}, valid_session
        expect(response).to redirect_to(Lead.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lead as @lead" do
        post :create, {lead: invalid_attributes}, valid_session
        expect(assigns(:lead)).to be_a_new(Lead)
      end

      it "re-renders the 'new' template" do
        post :create, {lead: invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
          name: 'Mark'
        }
      }

      it "updates the requested lead" do
        lead = Lead.create! valid_attributes
        put :update, {id: lead.to_param, lead: new_attributes}, valid_session
        lead.reload
        expect(lead.name).to eql("Mark")
      end

      it "assigns the requested lead as @lead" do
        lead = Lead.create! valid_attributes
        put :update, {id: lead.to_param, lead: valid_attributes}, valid_session
        expect(assigns(:lead)).to eq(lead)
      end

      it "redirects to the lead" do
        lead = Lead.create! valid_attributes
        put :update, {id: lead.to_param, lead: valid_attributes}, valid_session
        expect(response).to redirect_to(lead)
      end
    end

    describe "with invalid params" do
      it "assigns the lead as @lead" do
        lead = Lead.create! valid_attributes
        put :update, {id: lead.to_param, lead: invalid_attributes}, valid_session
        expect(assigns(:lead)).to eq(lead)
      end

      it "re-renders the 'edit' template" do
        lead = Lead.create! valid_attributes
        put :update, {id: lead.to_param, lead: invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lead" do
      lead = Lead.create! valid_attributes
      expect {
        delete :destroy, {id: lead.to_param}, valid_session
      }.to change(Lead, :count).by(-1)
    end

    it "redirects to the leads list" do
      lead = Lead.create! valid_attributes
      delete :destroy, {id: lead.to_param}, valid_session
      expect(response).to redirect_to(leads_url)
    end
  end

end
