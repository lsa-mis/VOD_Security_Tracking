require "rails_helper"

RSpec.describe "File attachments", type: :request do
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

  describe "GET /application/delete_file_attachment/:id" do
    it "purges an attached file" do
      dpa_exception.attachments.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "test.pdf")),
        filename: "test.pdf",
        content_type: "application/pdf"
      )
      attachment = dpa_exception.attachments.first

      expect {
        get delete_file_path(attachment)
      }.to change { dpa_exception.reload.attachments.count }.by(-1)
    end
  end
end
