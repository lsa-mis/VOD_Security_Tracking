# == Schema Information
#
# Table name: legacy_os_records
#
#  id                            :bigint           not null, primary key
#  owner_username                :string(255)      not null
#  owner_full_name               :string(255)      not null
#  phone                         :string(255)
#  additional_dept_contact       :string(255)
#  additional_dept_contact_phone :string(255)
#  support_poc                   :string(255)
#  legacy_os                     :string(255)
#  unique_app                    :string(255)
#  unique_hardware               :string(255)
#  unique_date                   :datetime
#  exception_approval_date       :datetime
#  review_date                   :datetime
#  review_contact                :string(255)
#  local_it_support_group        :string(255)
#  data_type_id                  :bigint
#  device_id                     :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#  incomplete                    :boolean          default(FALSE)
#  department_id                 :bigint           not null
#
require 'rails_helper'

RSpec.describe LegacyOsRecord, type: :model do
  
  let!(:device) { FactoryBot.create(:device) }
  let!(:data_classification_level) { FactoryBot.create(:data_classification_level) }
  let!(:data_type) { FactoryBot.create(:data_type, { data_classification_level: data_classification_level }) }
  let!(:department) { FactoryBot.create(:department) }
  let!(:legacy_os_record) { FactoryBot.create(:legacy_os_record) }


  it "is valid with valid attributes (including only unique_app)" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_app: "unique_app",
                              device: device)).to be_valid
  end

  it "is valid with valid attributes (including only unique_hardware)" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_hardware: "unique_hardware",
                              device: device)).to be_valid
  end

  it "is valid with valid attributes (including both unique_app and unique_hardware)" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_hardware: "unique_hardware", unique_app: "unique_app",
                              device: device)).to be_valid
  end

  it "is valid without a data_type" do
    device = Device.new(serial: "C02ZF95GLVDL")
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation", 
                              review_contact: "review_contact", department: department, phone: "123-345-6789", support_poc: "support_poc",
                              unique_date: "2021-03-19 16:50:16", unique_app: "unique_app",
                              device: device)).to be_valid
  end
  
  it "is not valid without a device" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation", 
                              review_contact: "review_contact", department: department, phone: "123-345-6789", support_poc: "support_poc",
                              unique_date: "2021-03-19 16:50:16", unique_app: "unique_app",
                              data_type: data_type)).to_not be_valid
  end

  it "is not valid without unique_app and unique_hardware" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation", 
                              review_contact: "review_contact", department: department, phone: "123-345-6789", support_poc: "support_poc",
                              unique_date: "2021-03-19 16:50:16",
                              device: device)).to_not be_valid
  end

  it "is incomplete with empty attributes" do
    legacy_os_record = LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              department: department, phone: "123-345-6789",
                              unique_app: "unique_app",
                              device: device)
    expect(legacy_os_record.not_completed?).to be(true)
  end

  it "is complete with all attributes" do
    expect(legacy_os_record.not_completed?).to be(false)
  end

  it "is valid with all attributes" do
    expect(legacy_os_record).to be_valid
  end

end

# working test
