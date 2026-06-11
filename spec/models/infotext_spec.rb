# == Schema Information
#
# Table name: infotexts
#
#  id         :bigint           not null, primary key
#  location   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Infotext, type: :model do
  it "is valid with a location" do
    infotext = FactoryBot.build(:infotext, location: "home")
    expect(infotext).to be_valid
  end

  it "cannot be saved without a location" do
    infotext = FactoryBot.build(:infotext, location: nil)
    expect { infotext.save }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it "stores rich text content" do
    infotext = FactoryBot.create(:infotext, location: "dashboard")
    infotext.content = "Welcome to the dashboard"
    infotext.save!

    expect(infotext.reload.content.to_plain_text).to eq("Welcome to the dashboard")
  end

  it "can be looked up by location" do
    infotext = FactoryBot.create(:infotext, location: "device_show")
    expect(Infotext.find_by(location: "device_show")).to eq(infotext)
  end
end
