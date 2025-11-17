# == Schema Information
#
# Table name: data_types
#
#  id                           :bigint           not null, primary key
#  name                         :string(255)
#  description                  :string(255)
#  description_link             :string(255)
#  data_classification_level_id :bigint           not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
require 'rails_helper'

RSpec.describe DataType, type: :model do

  let!(:data_classification_level) { FactoryBot.create(:data_classification_level) }

  it "is valid with required attributes" do
    expect(DataType.new(name: "name", description: "description", data_classification_level: data_classification_level)).to be_valid
  end

  it "is not valid without name" do
    expect(DataType.new(description: "description", data_classification_level: data_classification_level)).to_not be_valid
  end

  it "is not valid without data_classification_level_id" do
    expect(DataType.new(name: "name", description: "description")).to_not be_valid
  end

  it "should have a unique name" do
    DataType.create!(name: 'Abc', data_classification_level: data_classification_level)
    data_type = DataType.new(name: 'Abc', data_classification_level: data_classification_level)
    expect(data_type).to_not be_valid
    data_type.errors[:name].include?("has already be taken")
  end

  describe "associations" do
    it "belongs to data_classification_level" do
      data_type = FactoryBot.create(:data_type)
      expect(data_type.data_classification_level).to be_present
    end

    it "has many dpa_exceptions" do
      data_type = FactoryBot.create(:data_type)
      dpa_exception = FactoryBot.create(:dpa_exception, data_type: data_type)
      expect(data_type.dpa_exceptions).to include(dpa_exception)
    end

    it "has many it_security_incidents" do
      data_type = FactoryBot.create(:data_type)
      incident = FactoryBot.create(:it_security_incident, data_type: data_type)
      expect(data_type.it_security_incidents).to include(incident)
    end
  end

  describe "#display_name" do
    it "returns name and classification level" do
      level = FactoryBot.create(:data_classification_level, name: "Level 1")
      data_type = FactoryBot.create(:data_type, name: "Test Type", data_classification_level: level)
      expect(data_type.display_name).to include("Test Type")
      expect(data_type.display_name).to include("Level 1")
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(DataType.ransackable_attributes).to be_an(Array)
      expect(DataType.ransackable_attributes).to include("name", "description")
    end
  end

  describe ".ransackable_associations" do
    it "returns an array of searchable associations" do
      expect(DataType.ransackable_associations).to be_an(Array)
      expect(DataType.ransackable_associations).to include("data_classification_level")
    end
  end
end
