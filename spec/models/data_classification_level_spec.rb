# == Schema Information
#
# Table name: data_classification_levels
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe DataClassificationLevel, type: :model do
  before(:each) do
    # Clean up all dependent records in the correct order
    DpaException.destroy_all
    ItSecurityIncident.destroy_all
    LegacyOsRecord.destroy_all
    SensitiveDataSystem.destroy_all
    DataType.destroy_all
    DataClassificationLevel.destroy_all
  end

  it "should have a unique name" do
    # Create first record using factory
    FactoryBot.create(:data_classification_level, name: 'High')

    # Try to create another record with the same name
    duplicate_level = FactoryBot.build(:data_classification_level, name: 'High')
    expect(duplicate_level).to_not be_valid
    expect(duplicate_level.errors[:name]).to include("has already been taken")
  end

  it "is not valid without name" do
    data_classification_level = FactoryBot.build(:data_classification_level, name: nil)
    expect(data_classification_level).to_not be_valid
  end
end
