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

  it "is not valid with closedate > opendate" do
    notification = FactoryBot.build(:notification, 
                  opendate: 5.days.from_now,
                  closedate: 2.days.from_now)
    notification.errors[:closedate].include?("must be after the start date")
    notification.destroy
  end

end
