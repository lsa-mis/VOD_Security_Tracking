# == Schema Information
#
# Table name: storage_locations
#
#  id                 :bigint           not null, primary key
#  name               :string(255)
#  description        :string(255)
#  description_link   :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  device_is_required :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe StorageLocation, type: :model do

  it "should have a unique name" do
    StorageLocation.create!(name: 'Local')
    storage_location = StorageLocation.new(name: 'Local')
    expect(storage_location).to_not be_valid
    storage_location.errors[:name].include?("has already be taken")
  end

  it "is not valid without name" do
    expect(StorageLocation.new(description: "description")).to_not be_valid
  end

end
