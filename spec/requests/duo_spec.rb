require "rails_helper"

RSpec.describe "Duo authentication", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
    allow(Rails.application.credentials).to receive(:duo).and_return(
      {
        duo_ikey: "ikey",
        duo_skey: "skey",
        duo_akey: "akey",
        duo_host: "api-xxxx.duosecurity.com"
      }
    )
  end

  let(:user) { FactoryBot.create(:user) }

  describe "GET /registrations/duo" do
    it "redirects unauthenticated users to root" do
      get duo_path
      expect(response).to redirect_to(root_path)
    end

    it "renders the duo challenge for signed-in users" do
      allow(Duo).to receive(:sign_request).and_return("signed-request")
      sign_in user
      set_session(:user_memberships, ["test-group"])

      get duo_path
      expect(response).to have_http_status(:success)
      expect(Duo).to have_received(:sign_request).with("ikey", "skey", "akey", user.username)
    end
  end

  describe "POST /registrations/duo_verify" do
    it "sets duo_auth and redirects to dashboard on success" do
      allow(Duo).to receive(:verify_response).and_return(user.username)
      sign_in user
      set_session(:user_memberships, ["test-group"])

      post duo_verify_path, params: { sig_response: "valid-sig" }
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects to sign in when verification fails" do
      allow(Duo).to receive(:verify_response).and_return(nil)
      sign_in user
      set_session(:user_memberships, ["test-group"])

      post duo_verify_path, params: { sig_response: "invalid-sig" }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "Duo gate on protected pages" do
    it "redirects to duo when session is not duo-authenticated" do
      FactoryBot.create(:access_lookup, vod_table: "dpa_exceptions", ldap_group: "test-group")
      sign_in user
      set_session(:user_memberships, ["test-group"])
      # intentionally omit duo_auth

      get dpa_exceptions_path
      expect(response).to redirect_to(duo_path)
    end
  end
end
