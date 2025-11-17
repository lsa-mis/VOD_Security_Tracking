require 'rails_helper'

RSpec.describe "LegacyOsRecords", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ['test-group']
    u
  end
  let(:department) { FactoryBot.create(:department) }
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: 'legacy_os_records', ldap_group: 'test-group') }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ['test-group'])
  end

  describe "GET /legacy_os_records" do
    it "returns success for authorized user" do
      access_lookup
      get legacy_os_records_path
      expect(response).to have_http_status(:success)
    end

    it "returns CSV format" do
      access_lookup
      FactoryBot.create(:legacy_os_record)
      get legacy_os_records_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/csv')
    end
  end

  describe "GET /legacy_os_records/:id" do
    let(:record) { FactoryBot.create(:legacy_os_record) }

    it "shows the legacy OS record" do
      access_lookup
      get legacy_os_record_path(record)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /archive_legacy_os_record/:id" do
    let(:record) { FactoryBot.create(:legacy_os_record) }

    it "archives the legacy OS record" do
      access_lookup
      post archive_legacy_os_record_path(record)
      expect(record.reload.deleted_at).to be_present
      expect(response).to redirect_to(legacy_os_records_path)
    end
  end

  describe "GET /legacy_os_records/audit_log/:id" do
    let(:record) { FactoryBot.create(:legacy_os_record) }

    it "shows audit log" do
      access_lookup
      get legacy_os_record_audit_log_path(record)
      expect(response).to have_http_status(:success)
    end
  end
end
