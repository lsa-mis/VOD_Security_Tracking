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
  
  it "should have a unique name" do
    DataClassificationLevel.create!(name: 'High')
    data_classification_level = DataClassificationLevel.new(name: 'High')
    expect(data_classification_level).to_not be_valid
    data_classification_level.errors[:name].include?("has already be taken")
  end

  it "is not valid without name" do
    expect(DataClassificationLevel.new(description: "description")).to_not be_valid
  end
end
