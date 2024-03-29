# == Schema Information
#
# Table name: devices
#
#  id           :bigint           not null, primary key
#  serial       :string(255)
#  hostname     :string(255)
#  mac          :string(255)
#  building     :string(255)
#  room         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner        :string(255)
#  department   :string(255)
#  manufacturer :string(255)
#  model        :string(255)
#
require 'rails_helper'

RSpec.describe Device, type: :model do

  it "is valid with serial and/or hostname attributes" do
    device = FactoryBot.create(:device)
    expect(device).to be_valid
    device.destroy
    expect(Device.new(serial: "serial")).to be_valid
    expect(Device.new(hostname: "hostname")).to be_valid
  end

end
