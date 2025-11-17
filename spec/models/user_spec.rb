# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  email               :string(255)      default("")
#  remember_created_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  failed_attempts     :integer          default(0), not null
#  unlock_token        :string(255)
#  locked_at           :datetime
#  username            :string(255)      default(""), not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    allow(Devise::LDAP::Adapter).to receive(:get_ldap_param).with(anything, "mail").and_return(["test@example.com"])
  end

  describe "validations" do
    it "is valid with a username" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end

  describe "callbacks" do
    it "sets email address from LDAP before creation" do
      user = FactoryBot.build(:user)
      user.save
      expect(user.email).to eq("test@example.com")
    end
  end

  describe "scopes" do
    describe ".recent" do
      it "returns users who signed in within the last 2 days" do
        recent_user = FactoryBot.create(:user, current_sign_in_at: 1.day.ago)
        old_user = FactoryBot.create(:user, current_sign_in_at: 3.days.ago)

        expect(User.recent).to include(recent_user)
        expect(User.recent).not_to include(old_user)
      end
    end
  end

  describe "#display_name" do
    it "returns username and email" do
      user = FactoryBot.create(:user, username: "testuser", email: "test@example.com")
      expect(user.display_name).to eq("testuser - test@example.com")
    end
  end

  describe "#display_login_info" do
    it "returns username, email, and last login time" do
      login_time = 1.day.ago
      user = FactoryBot.create(:user, username: "testuser", email: "test@example.com", current_sign_in_at: login_time)
      expect(user.display_login_info).to include("testuser - test@example.com")
      expect(user.display_login_info).to include("Last logged in at:")
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(User.ransackable_attributes).to be_an(Array)
      expect(User.ransackable_attributes).to include("username", "email", "created_at")
    end
  end
end
