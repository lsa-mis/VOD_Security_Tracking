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
    # Clean up any existing records with this name
    StorageLocation.where(name: 'Local').destroy_all

    # Create first record
    StorageLocation.create!(name: 'Local')

    # Try to create second record with same name
    storage_location = StorageLocation.new(name: 'Local')
    expect(storage_location).not_to be_valid
    expect(storage_location.errors[:name]).to include("has already been taken")
  end

  it "is not valid without name" do
    expect(StorageLocation.new(description: "description")).to_not be_valid
  end

end
