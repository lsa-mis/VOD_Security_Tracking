require "rails_helper"

RSpec.describe Admin::ApplicationPolicy do
  let(:admin_group) { "lsa-vod-admins" }
  let(:user) { FactoryBot.build(:user) }
  let(:record) { FactoryBot.build(:department) }

  before do
    FactoryBot.create(:access_lookup, ldap_group: admin_group, vod_table: :admin_interface, vod_action: :all)
  end

  it "allows members of admin_interface groups" do
    user.membership = [admin_group]
    policy = described_class.new(user, record)
    expect(policy.index?).to eq(true)
    expect(policy.destroy?).to eq(true)
  end

  it "denies users without admin groups" do
    user.membership = ["other"]
    policy = described_class.new(user, record)
    expect(policy.index?).to eq(false)
  end
end
