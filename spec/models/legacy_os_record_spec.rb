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
  # let(:legacy_os_record) {FactoryBot.build :legacy_os_record}

  it "is valid with valid attributes" do
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok",
                              dept: "Department", phone: "123-345-6789",
                              unique_app: "unique_app",
                              device: device)).to be_valid
    # legacy_os_record = FactoryBot.build(:legacy_os_record)
    # expect(legacy_os_record).to be_valid
  end
  
  it "is not valid without a device" do
    # legacy_os_record = FactoryBot.build(:legacy_os_record)
    # legacy_os_record.device_id = nil
    # expect(legacy_os_record).to_not be_valid
    expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation", 
                              review_contact: "review_contact", dept: "Department", phone: "123-345-6789", support_poc: "support_poc",
                              unique_date: "2021-03-19 16:50:16", unique_app: "unique_app",
                              data_type: data_type)).to_not be_valid
  end

  # it "is not valid without a data_type" do
  #   expect(LegacyOsRecord.new(owner_username: "brita", owner_full_name: "Rita Barvinok", remediation: "remediation", 
  #                             review_contact: "review_contact", dept: "Department", phone: "123-345-6789", support_poc: "support_poc",
  #                             unique_date: "2021-03-19 16:50:16", unique_app: "unique_app",
  #                             device: device)).to_not be_valid
  # end

end
