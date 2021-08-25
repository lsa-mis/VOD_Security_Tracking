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

end

# working test