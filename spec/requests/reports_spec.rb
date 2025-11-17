require 'rails_helper'

RSpec.describe "Reports", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ['test-group']
    u
  end
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: 'admin_interface', ldap_group: 'test-group') }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ['test-group'])
  end

  describe "GET /reports" do
    it "returns success for authorized user" do
      access_lookup
      get reports_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /run_report" do
    it "generates report" do
      access_lookup
      FactoryBot.create(:dpa_exception)
      get run_report_path, params: {
        table: "dpa",
        report_data: {
          start_date: "",
          end_date: Date.today.strftime("%Y-%m-%d")
        },
        data_classification_level_id: "",
        data_type_id: ""
      }
      expect(response).to have_http_status(:success)
    end

    it "returns CSV format" do
      access_lookup
      FactoryBot.create(:dpa_exception)
      get run_report_path(format: :csv), params: {
        table: "dpa",
        report_data: {
          start_date: "",
          end_date: Date.today.strftime("%Y-%m-%d")
        },
        data_classification_level_id: "",
        data_type_id: ""
      }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/csv')
    end
  end
end
