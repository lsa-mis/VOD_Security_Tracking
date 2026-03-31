require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /users/sign_in" do
    it "redirects with a VPN/network message when LDAP times out" do
      allow(Devise::LDAP::Adapter).to receive(:valid_credentials?).and_raise(Net::LDAP::Error, "Operation timed out")

      post user_session_path, params: {
        user: {
          username: "rsmoke",
          password: "password123"
        }
      }

      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq("Cannot reach LDAP right now. Connect to VPN or campus network and try again.")
    end
  end
end
