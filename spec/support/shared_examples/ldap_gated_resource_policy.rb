RSpec.shared_examples "an LDAP-gated resource policy" do |table_name|
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@example.com"])
  end

  let(:user) do
    u = FactoryBot.create(:user)
    u.membership = ["test-group"]
    u
  end
  let(:access_lookup) { FactoryBot.create(:access_lookup, vod_table: table_name, ldap_group: "test-group") }

  describe "#index?" do
    it "allows access when user is in required LDAP group" do
      access_lookup
      expect(subject.index?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.index?).to be false
    end
  end

  describe "#show?" do
    it "allows access when user is in required LDAP group" do
      access_lookup
      expect(subject.show?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.show?).to be false
    end
  end

  describe "#new?" do
    it "allows access when user is in newedit LDAP group" do
      FactoryBot.create(:access_lookup, vod_table: table_name, vod_action: "newedit", ldap_group: "test-group")
      expect(subject.new?).to be true
    end

    it "allows access when user is in 'all' action group" do
      FactoryBot.create(:access_lookup, vod_table: table_name, vod_action: "all", ldap_group: "test-group")
      expect(subject.new?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.new?).to be false
    end
  end

  describe "#edit?" do
    it "allows access when user is in newedit LDAP group" do
      FactoryBot.create(:access_lookup, vod_table: table_name, vod_action: "newedit", ldap_group: "test-group")
      expect(subject.edit?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.edit?).to be false
    end
  end

  describe "#archive?" do
    it "allows access when user is in archive LDAP group" do
      FactoryBot.create(:access_lookup, vod_table: table_name, vod_action: "archive", ldap_group: "test-group")
      expect(subject.archive?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.archive?).to be false
    end
  end

  describe "#audit_log?" do
    it "allows access when user is in audit LDAP group" do
      FactoryBot.create(:access_lookup, vod_table: table_name, vod_action: "audit", ldap_group: "test-group")
      expect(subject.audit_log?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.audit_log?).to be false
    end
  end

  describe "#any_action?" do
    it "allows access when user is in any LDAP group for the table" do
      access_lookup
      expect(subject.any_action?).to be true
    end

    it "denies access when user is not in required LDAP group" do
      user.membership = []
      expect(subject.any_action?).to be false
    end
  end
end
