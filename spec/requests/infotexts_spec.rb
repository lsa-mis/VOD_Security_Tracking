require "rails_helper"

RSpec.describe "Infotexts", type: :request do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@test.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ["test-group"]
    u
  end
  let(:infotext) { FactoryBot.create(:infotext, location: "home") }
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: "admin_interface", ldap_group: "test-group") }

  before do
    sign_in user
    set_session(:duo_auth, true)
    set_session(:user_memberships, ["test-group"])
  end

  describe "GET /infotexts" do
    it "returns success for authorized admin users" do
      access_lookup
      get infotexts_path
      expect(response).to have_http_status(:success)
    end

    it "redirects unauthorized users" do
      set_session(:user_memberships, ["other-group"])
      get infotexts_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /infotexts/:id" do
    it "shows an infotext" do
      access_lookup
      get infotext_path(infotext)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /infotexts/:id/edit" do
    it "shows the edit form for authorized users" do
      access_lookup
      get edit_infotext_path(infotext)
      expect(response).to have_http_status(:success)
    end
  end
end
