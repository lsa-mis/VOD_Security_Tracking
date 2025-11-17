require 'rails_helper'

RSpec.describe "ItSecurityIncidents", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ['test-group']
    u
  end
  let(:data_type) { FactoryBot.create(:data_type) }
  let(:it_security_incident_status) { FactoryBot.create(:it_security_incident_status) }
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: 'it_security_incidents', ldap_group: 'test-group') }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ['test-group'])
  end

  describe "GET /it_security_incidents" do
    it "returns success for authorized user" do
      access_lookup
      get it_security_incidents_path
      expect(response).to have_http_status(:success)
    end

    it "returns CSV format" do
      access_lookup
      FactoryBot.create(:it_security_incident)
      get it_security_incidents_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/csv')
    end
  end

  describe "GET /it_security_incidents/:id" do
    let(:incident) { FactoryBot.create(:it_security_incident) }

    it "shows the incident" do
      access_lookup
      get it_security_incident_path(incident)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /it_security_incidents/new" do
    it "shows new form for authorized user" do
      access_lookup
      get new_it_security_incident_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /it_security_incidents" do
    let(:valid_params) do
      {
        it_security_incident: {
          title: "Test Incident",
          date: Date.today,
          people_involved: "Test people",
          equipment_involved: "Test equipment",
          remediation_steps: "Test steps",
          data_type_id: data_type.id,
          it_security_incident_status_id: it_security_incident_status.id,
          tdx_ticket: { ticket_link: "" }
        }
      }
    end

    it "creates a new incident" do
      access_lookup
      expect {
        post it_security_incidents_path, params: valid_params
      }.to change(ItSecurityIncident, :count).by(1)
      expect(response).to redirect_to(it_security_incident_path(ItSecurityIncident.last))
    end
  end

  describe "POST /archive_it_security_incident/:id" do
    let(:incident) { FactoryBot.create(:it_security_incident) }

    it "archives the incident" do
      access_lookup
      post archive_it_security_incident_path(incident)
      expect(incident.reload.deleted_at).to be_present
      expect(response).to redirect_to(it_security_incidents_path)
    end
  end

  describe "GET /it_security_incidents/audit_log/:id" do
    let(:incident) { FactoryBot.create(:it_security_incident) }

    it "shows audit log" do
      access_lookup
      get it_security_incident_audit_log_path(incident)
      expect(response).to have_http_status(:success)
    end
  end
end
