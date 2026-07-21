require "rails_helper"

RSpec.describe Admin::CommentPolicy, type: :policy do
  let(:admin_group) { "lsa-vod-admins" }
  let(:user) { FactoryBot.build(:user) }
  let(:comment) { Comment.new(body: "Note") }

  before do
    FactoryBot.create(:access_lookup, ldap_group: admin_group, vod_table: :admin_interface, vod_action: :all)
  end

  subject { described_class.new(user, comment) }

  it "inherits admin CRUD permissions" do
    user.membership = [admin_group]
    expect(subject.index?).to eq(true)
    expect(subject.create?).to eq(true)
    expect(subject.update?).to eq(true)
    expect(subject.destroy?).to eq(true)
    expect(subject.batch_destroy?).to eq(true)
  end

  it "denies users without admin groups" do
    user.membership = ["other"]
    expect(subject.index?).to eq(false)
    expect(subject.create?).to eq(false)
  end
end
