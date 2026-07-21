require "rails_helper"

RSpec.describe "Nested TDX tickets", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ["test-group"]
    u
  end
  let(:dpa_exception) { FactoryBot.create(:dpa_exception) }

  before do
    FactoryBot.create(:access_lookup, vod_table: "dpa_exceptions", ldap_group: "test-group")
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ["test-group"])
  end

  describe "POST /dpa_exceptions/:dpa_exception_id/tdx_tickets" do
    it "creates a ticket for the parent record" do
      expect {
        post dpa_exception_tdx_tickets_path(dpa_exception),
             params: { tdx_ticket: { ticket_link: "https://example.com/ticket/1" } },
             as: :turbo_stream
      }.to change(TdxTicket, :count).by(1)

      expect(response).to redirect_to(dpa_exception_path(dpa_exception))
      expect(dpa_exception.tdx_tickets.last.ticket_link).to eq("https://example.com/ticket/1")
    end

    it "does not create a ticket without a link" do
      expect {
        post dpa_exception_tdx_tickets_path(dpa_exception),
             params: { tdx_ticket: { ticket_link: "" } },
             as: :turbo_stream
      }.not_to change(TdxTicket, :count)

      expect(response).to redirect_to(dpa_exception_path(dpa_exception))
      expect(flash[:alert]).to include("ticket link")
    end
  end

  describe "DELETE /dpa_exceptions/:dpa_exception_id/tdx_tickets/:id" do
    it "destroys the ticket" do
      ticket = FactoryBot.create(:tdx_ticket, :for_dpa_exception, records_to_tdx: dpa_exception)

      expect {
        delete dpa_exception_tdx_ticket_path(dpa_exception, ticket)
      }.to change(TdxTicket, :count).by(-1)
    end
  end

  describe "POST nested tickets for other parents" do
    it "creates a ticket on an IT security incident" do
      FactoryBot.create(:access_lookup, vod_table: "it_security_incidents", ldap_group: "test-group")
      incident = FactoryBot.create(:it_security_incident)

      expect {
        post it_security_incident_tdx_tickets_path(incident),
             params: { tdx_ticket: { ticket_link: "https://example.com/isi/1" } },
             as: :turbo_stream
      }.to change(TdxTicket, :count).by(1)
    end

    it "creates a ticket on a legacy OS record" do
      FactoryBot.create(:access_lookup, vod_table: "legacy_os_records", ldap_group: "test-group")
      record = FactoryBot.create(:legacy_os_record)

      expect {
        post legacy_os_record_tdx_tickets_path(record),
             params: { tdx_ticket: { ticket_link: "https://example.com/lor/1" } },
             as: :turbo_stream
      }.to change(TdxTicket, :count).by(1)
    end

    it "creates a ticket on a sensitive data system" do
      FactoryBot.create(:access_lookup, vod_table: "sensitive_data_systems", ldap_group: "test-group")
      sds = FactoryBot.create(:sensitive_data_system)

      expect {
        post sensitive_data_system_tdx_tickets_path(sds),
             params: { tdx_ticket: { ticket_link: "https://example.com/sds/1" } },
             as: :turbo_stream
      }.to change(TdxTicket, :count).by(1)
    end
  end
end
