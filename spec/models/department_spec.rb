# == Schema Information
#
# Table name: departments
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  shortname        :string(255)
#  active_dir_group :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Department, type: :model do

  it "is valid with required attributes" do
    department = FactoryBot.create(:department)
    expect(department).to be_valid
  end

  it "is not valid without name" do
    expect(Department.new(shortname: "shortname")).to_not be_valid
  end

  it "is not valid without shortname" do
    expect(Department.new(name: "name")).to_not be_valid
  end

end

