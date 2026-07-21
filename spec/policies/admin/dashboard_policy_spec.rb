require "rails_helper"

RSpec.describe Admin::DashboardPolicy, type: :policy do
  let(:admin_group) { "lsa-vod-admins" }
  let(:user) { FactoryBot.build(:user) }

  before do
    FactoryBot.create(:access_lookup, ldap_group: admin_group, vod_table: :admin_interface, vod_action: :all)
  end

  subject { described_class.new(user, :dashboard) }

  describe "#show?" do
    it "allows members of admin_interface groups" do
      user.membership = [admin_group]
      expect(subject.show?).to eq(true)
    end

    it "denies users without admin groups" do
      user.membership = ["other"]
      expect(subject.show?).to eq(false)
    end
  end
end
