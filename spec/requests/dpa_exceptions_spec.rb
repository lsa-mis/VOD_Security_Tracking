require 'rails_helper'

RSpec.describe "DpaExceptions", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ['test-group']
    u
  end
  let(:department) { FactoryBot.create(:department) }
  let(:dpa_exception_status) { FactoryBot.create(:dpa_exception_status) }
  let(:data_type) { FactoryBot.create(:data_type) }
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', ldap_group: 'test-group') }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ['test-group'])
  end

  describe "GET /dpa_exceptions" do
    it "returns success for authorized user" do
      access_lookup
      get dpa_exceptions_path
      expect(response).to have_http_status(:success)
    end

    it "redirects unauthorized user" do
      user.membership = []
      get dpa_exceptions_path
      expect(response).to redirect_to(root_path)
    end

    it "returns CSV format" do
      access_lookup
      FactoryBot.create(:dpa_exception)
      get dpa_exceptions_path(format: :csv)
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/csv')
    end
  end

  describe "GET /dpa_exceptions/:id" do
    let(:dpa_exception) { FactoryBot.create(:dpa_exception) }

    it "shows the dpa exception" do
      access_lookup
      get dpa_exception_path(dpa_exception)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /dpa_exceptions/new" do
    it "shows new form for authorized user" do
      access_lookup
      FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', vod_action: 'newedit', ldap_group: 'test-group')
      get new_dpa_exception_path
      expect(response).to have_http_status(:success)
    end

    it "redirects unauthorized user" do
      get new_dpa_exception_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST /dpa_exceptions" do
  let(:valid_params) do
    {
      dpa_exception: {
        third_party_product_service: "Test Service",
        department_id: department.id,
        dpa_exception_status_id: dpa_exception_status.id,
        review_date_exception_first_approval_date: Date.today,
        tdx_ticket: { ticket_link: "" }
      }
    }
  end

    it "creates a new dpa exception" do
      FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', vod_action: 'newedit', ldap_group: 'test-group')
      expect {
        post dpa_exceptions_path, params: valid_params
      }.to change(DpaException, :count).by(1)
      expect(response).to redirect_to(dpa_exception_path(DpaException.last))
    end

    it "does not create with invalid params" do
      FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', vod_action: 'newedit', ldap_group: 'test-group')
      # Create invalid params but ensure tdx_ticket is present to avoid nil error
      invalid_params = valid_params.deep_dup
      invalid_params[:dpa_exception][:third_party_product_service] = nil
      expect {
        post dpa_exceptions_path, params: invalid_params
      }.not_to change(DpaException, :count)
    end
  end

  describe "GET /dpa_exceptions/:id/edit" do
    let(:dpa_exception) { FactoryBot.create(:dpa_exception) }

    it "shows edit form for authorized user" do
      FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', vod_action: 'newedit', ldap_group: 'test-group')
      get edit_dpa_exception_path(dpa_exception)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /dpa_exceptions/:id" do
    let(:dpa_exception) { FactoryBot.create(:dpa_exception) }

    it "updates the dpa exception" do
      FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', vod_action: 'newedit', ldap_group: 'test-group')
      patch dpa_exception_path(dpa_exception), params: {
        dpa_exception: {
          third_party_product_service: "Updated Service",
          tdx_ticket: { ticket_link: "" }
        }
      }
      expect(dpa_exception.reload.third_party_product_service).to eq("Updated Service")
      expect(response).to redirect_to(dpa_exception_path(dpa_exception))
    end
  end

  describe "POST /archive_dpa_exception/:id" do
    let(:dpa_exception) { FactoryBot.create(:dpa_exception) }

    it "archives the dpa exception" do
      FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', vod_action: 'archive', ldap_group: 'test-group')
      post archive_dpa_exception_path(dpa_exception)
      expect(dpa_exception.reload.deleted_at).to be_present
      expect(response).to redirect_to(dpa_exceptions_path)
    end
  end

  describe "GET /dpa_exceptions/audit_log/:id" do
    let(:dpa_exception) { FactoryBot.create(:dpa_exception) }

    it "shows audit log for authorized user" do
      FactoryBot.create(:access_lookup, vod_table: 'dpa_exceptions', vod_action: 'audit', ldap_group: 'test-group')
      get dpa_exception_audit_log_path(dpa_exception)
      expect(response).to have_http_status(:success)
    end
  end
end
