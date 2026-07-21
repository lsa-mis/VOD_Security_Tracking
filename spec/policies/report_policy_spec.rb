require "rails_helper"

RSpec.describe ReportPolicy, type: :policy do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@example.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ["test-group"]
    u
  end
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: "admin_interface", ldap_group: "test-group") }

  subject { described_class.new(user, :report) }

  describe "#index?" do
    it "allows access when user is in admin_interface LDAP group" do
      access_lookup
      expect(subject.index?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.index?).to be false
    end
  end

  describe "#show?" do
    it "allows access when user is in admin_interface LDAP group" do
      access_lookup
      expect(subject.show?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.show?).to be false
    end
  end
end
