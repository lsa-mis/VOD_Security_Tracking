require 'rails_helper'

RSpec.describe "SensitiveDataSystems", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ['test-group']
    u
  end
  let(:department) { FactoryBot.create(:department) }
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: 'sensitive_data_systems', ldap_group: 'test-group') }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ['test-group'])
  end

  describe "GET /sensitive_data_systems" do
    it "returns success for authorized user" do
      access_lookup
      get sensitive_data_systems_path
      expect(response).to have_http_status(:success)
    end

    it "returns CSV format" do
      access_lookup
      FactoryBot.create(:sensitive_data_system)
      get sensitive_data_systems_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/csv')
    end
  end

  describe "GET /sensitive_data_systems/:id" do
    let(:sds) { FactoryBot.create(:sensitive_data_system) }

    it "shows the sensitive data system" do
      access_lookup
      get sensitive_data_system_path(sds)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /archive_sensitive_data_system/:id" do
    let(:sds) { FactoryBot.create(:sensitive_data_system) }

    it "archives the sensitive data system" do
      access_lookup
      post archive_sensitive_data_system_path(sds)
      expect(sds.reload.deleted_at).to be_present
      expect(response).to redirect_to(sensitive_data_systems_path)
    end
  end

  describe "GET /sensitive_data_systems/audit_log/:id" do
    let(:sds) { FactoryBot.create(:sensitive_data_system) }

    it "shows audit log" do
      access_lookup
      get sensitive_data_system_audit_log_path(sds)
      expect(response).to have_http_status(:success)
    end
  end
end
