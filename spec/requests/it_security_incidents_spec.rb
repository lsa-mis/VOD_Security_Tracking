 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/it_security_incidents", type: :request do
  
  # ItSecurityIncident. As you add validations to ItSecurityIncident, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      ItSecurityIncident.create! valid_attributes
      get it_security_incidents_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      it_security_incident = ItSecurityIncident.create! valid_attributes
      get it_security_incident_url(it_security_incident)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_it_security_incident_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      it_security_incident = ItSecurityIncident.create! valid_attributes
      get edit_it_security_incident_url(it_security_incident)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ItSecurityIncident" do
        expect {
          post it_security_incidents_url, params: { it_security_incident: valid_attributes }
        }.to change(ItSecurityIncident, :count).by(1)
      end

      it "redirects to the created it_security_incident" do
        post it_security_incidents_url, params: { it_security_incident: valid_attributes }
        expect(response).to redirect_to(it_security_incident_url(ItSecurityIncident.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ItSecurityIncident" do
        expect {
          post it_security_incidents_url, params: { it_security_incident: invalid_attributes }
        }.to change(ItSecurityIncident, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post it_security_incidents_url, params: { it_security_incident: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested it_security_incident" do
        it_security_incident = ItSecurityIncident.create! valid_attributes
        patch it_security_incident_url(it_security_incident), params: { it_security_incident: new_attributes }
        it_security_incident.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the it_security_incident" do
        it_security_incident = ItSecurityIncident.create! valid_attributes
        patch it_security_incident_url(it_security_incident), params: { it_security_incident: new_attributes }
        it_security_incident.reload
        expect(response).to redirect_to(it_security_incident_url(it_security_incident))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        it_security_incident = ItSecurityIncident.create! valid_attributes
        patch it_security_incident_url(it_security_incident), params: { it_security_incident: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested it_security_incident" do
      it_security_incident = ItSecurityIncident.create! valid_attributes
      expect {
        delete it_security_incident_url(it_security_incident)
      }.to change(ItSecurityIncident, :count).by(-1)
    end

    it "redirects to the it_security_incidents list" do
      it_security_incident = ItSecurityIncident.create! valid_attributes
      delete it_security_incident_url(it_security_incident)
      expect(response).to redirect_to(it_security_incidents_url)
    end
  end
end
