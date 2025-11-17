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

  describe "validations" do
    it "validates uniqueness of name" do
      FactoryBot.create(:department, name: "Test Dept", shortname: "TD1")
      duplicate = Department.new(name: "Test Dept", shortname: "TD2")
      expect(duplicate).not_to be_valid
    end

    it "validates uniqueness of shortname" do
      FactoryBot.create(:department, name: "Dept 1", shortname: "D1")
      duplicate = Department.new(name: "Dept 2", shortname: "D1")
      expect(duplicate).not_to be_valid
    end
  end

  describe "associations" do
    it "has many legacy_os_records" do
      department = FactoryBot.create(:department)
      record = FactoryBot.create(:legacy_os_record, department: department)
      expect(department.legacy_os_records).to include(record)
    end

    it "has many sensitive_data_systems" do
      department = FactoryBot.create(:department)
      sds = FactoryBot.create(:sensitive_data_system, department: department)
      expect(department.sensitive_data_systems).to include(sds)
    end

    it "has many dpa_exceptions" do
      department = FactoryBot.create(:department)
      dpa = FactoryBot.create(:dpa_exception, department: department)
      expect(department.dpa_exceptions).to include(dpa)
    end
  end

  describe "#display_name" do
    it "returns department name" do
      department = FactoryBot.create(:department, name: "Test Department")
      expect(department.display_name).to eq("Test Department")
    end
  end

  describe ".ransackable_attributes" do
    it "returns an array of searchable attributes" do
      expect(Department.ransackable_attributes).to be_an(Array)
      expect(Department.ransackable_attributes).to include("name", "shortname")
    end
  end

  describe ".ransackable_associations" do
    it "returns an array of searchable associations" do
      expect(Department.ransackable_associations).to be_an(Array)
      expect(Department.ransackable_associations).to include("dpa_exceptions", "legacy_os_records")
    end
  end
end
