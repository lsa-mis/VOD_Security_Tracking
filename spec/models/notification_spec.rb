# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  note       :string(255)
#  opendate   :datetime
#  closedate  :datetime
#  notetype   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Notification, type: :model do
  it "is valid with required attributes" do
    notification = FactoryBot.create(:notification)
    expect(notification).to be_valid
    notification.destroy
  end

  it "is not valid without name" do
    notification = FactoryBot.build(:notification, note: "")
    expect(notification).to_not be_valid
    notification.destroy
  end

  it "is not valid without opendate" do
    notification = FactoryBot.build(:notification, opendate: "")
    expect(notification).to_not be_valid
    notification.destroy
  end

  it "is not valid without closedate" do
    notification = FactoryBot.build(:notification, closedate: "")
    expect(notification).to_not be_valid
    notification.destroy
  end

  it "is not valid with closedate before opendate" do
    notification = FactoryBot.build(:notification,
                  opendate: 5.days.from_now,
                  closedate: 2.days.from_now)
    expect(notification).not_to be_valid
    expect(notification.errors[:closedate]).to include("must be after the start date")
  end

  describe "availability overlap validation" do
    it "rejects notifications whose dates overlap an existing notification" do
      FactoryBot.create(
        :notification,
        opendate: 1.day.from_now,
        closedate: 10.days.from_now
      )

      overlapping = FactoryBot.build(
        :notification,
        opendate: 5.days.from_now,
        closedate: 15.days.from_now
      )

      expect(overlapping).not_to be_valid
      expect(overlapping.errors[:opendate]).to include("not available")
    end

    it "allows notifications outside existing date ranges" do
      FactoryBot.create(
        :notification,
        opendate: 1.day.from_now,
        closedate: 3.days.from_now
      )

      non_overlapping = FactoryBot.build(
        :notification,
        opendate: 5.days.from_now,
        closedate: 8.days.from_now
      )

      expect(non_overlapping).to be_valid
    end
  end

  describe "scopes" do
    describe ".active" do
      it "returns notifications with closedate in the future" do
        active = FactoryBot.create(:notification, opendate: 1.day.ago, closedate: 1.day.from_now)
        # Create expired notification with dates that don't conflict with active one
        expired = FactoryBot.create(:notification, opendate: 3.days.ago, closedate: 2.days.ago)

        expect(Notification.active).to include(active)
        expect(Notification.active).not_to include(expired)
      end
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(Notification.ransackable_attributes).to be_an(Array)
      expect(Notification.ransackable_attributes).to include("note", "notetype", "opendate", "closedate")
    end
  end
end
